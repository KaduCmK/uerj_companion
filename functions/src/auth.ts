import * as admin from "firebase-admin";
import { auth } from "firebase-functions/v1";
import { beforeUserCreated, HttpsError } from "firebase-functions/identity";
import { Timestamp } from "firebase-admin/firestore";

// Bloqueia a criação de usuarios que nao pertencem ao dominio de estudantes de graduacao da uerj
export const beforeCreate = beforeUserCreated((event) => {
    const user = event.data;

    if (!user?.email || !user.email.endsWith("@graduacao.uerj.br")) {
        throw new HttpsError(
            "invalid-argument",
            "Apenas universitários da graduação são permitidos"
        )
    }
})

// Cria o doc de usuario correspondente dentro do Firestore
export const createFirestoreUser = auth.user().onCreate((user) => {
    console.log("Novo usuario sendo cadastrado no Firestore");

    const db = admin.firestore();
    const userRef = db.collection("users").doc(user.uid);
    
    return userRef.set({
        nome: user.displayName,
        email: user.email,
        createdAt: Timestamp.now(),
        role: 'estudante'
    });
})