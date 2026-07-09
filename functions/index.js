const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const logger = require("firebase-functions/logger");

initializeApp();

/**
 * chats/{chatId}/messages altına yeni mesaj yazıldığında tetiklenir.
 *
 * İki yön de desteklenir:
 * - Freelancer mesaj atarsa → hizmet alana bildirim gider
 * - Hizmet alan mesaj atarsa → freelancer'a bildirim gider
 */
exports.onNewChatMessage = onDocumentCreated(
  {
    document: "chats/{chatId}/messages/{messageId}",
    region: "europe-west1",
  },
  async (event) => {
    const message = event.data ? event.data.data() : null;
    if (!message || !message.senderId) return;

    const db = getFirestore();
    const chatSnap = await db
      .collection("chats")
      .doc(event.params.chatId)
      .get();
    const chat = chatSnap.data();
    if (!chat) {
      logger.warn(`Chat bulunamadı: ${event.params.chatId}`);
      return;
    }

    // Göndereni belirle, karşı tarafa bildirim at
    let recipientId;
    let senderName;
    let notificationBody;
    let returnRoute;
    if (message.senderId === chat.freelancerId) {
      // Freelancer → hizmet alan
      recipientId = chat.clientId;
      senderName = chat.freelancerName || "Freelancer";
      notificationBody = `Teklif verdiğiniz ${senderName} size mesaj gönderdi.`;
      returnRoute = "/client/home";
    } else if (message.senderId === chat.clientId) {
      // Hizmet alan → freelancer
      recipientId = chat.freelancerId;
      senderName = chat.clientName || "Hizmet alan";
      notificationBody = `${senderName} size mesaj gönderdi.`;
      returnRoute = "/freelancer/home";
    } else {
      return;
    }
    if (!recipientId) return;

    const userSnap = await db.collection("users").doc(recipientId).get();
    const fcmToken = userSnap.get("fcmToken");
    if (!fcmToken) {
      logger.info(`Alıcının FCM token'ı yok: ${recipientId}`);
      return;
    }

    try {
      await getMessaging().send({
        token: fcmToken,
        notification: {
          title: "Yeni mesaj 📩",
          body: notificationBody,
        },
        data: {
          type: "chat_message",
          chatId: event.params.chatId,
          otherUserName: senderName,
          briefTitle: chat.briefTitle || "",
          returnRoute: returnRoute,
        },
        android: {
          priority: "high",
          notification: {
            defaultSound: true,
          },
        },
        apns: {
          payload: {
            aps: { sound: "default" },
          },
        },
      });
      logger.info(
        `Bildirim gönderildi → ${recipientId} (chat: ${event.params.chatId})`
      );
    } catch (err) {
      // Token geçersizse (uygulama silinmiş vb.) Firestore'dan temizle
      if (
        err.code === "messaging/registration-token-not-registered" ||
        err.code === "messaging/invalid-registration-token"
      ) {
        await userSnap.ref.update({ fcmToken: FieldValue.delete() });
        logger.info(`Geçersiz token silindi: ${recipientId}`);
      } else {
        logger.error("Bildirim gönderilemedi", err);
      }
    }
  }
);
