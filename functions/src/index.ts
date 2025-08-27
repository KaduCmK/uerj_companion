import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions";

setGlobalOptions({ maxInstances: 4 });
admin.initializeApp();

export * from "./auth";
export * from "./firestore";