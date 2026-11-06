# flychat

[![CI](https://github.com/Bisratasaye12/flychat/actions/workflows/ci.yml/badge.svg)](https://github.com/Bisratasaye12/flychat/actions/workflows/ci.yml)

A one-to-one chat app in Flutter. Sign up with email, pick someone from the user list, and messages show up on both sides in real time. It runs on Android, iOS and the web. On wide screens you get a two-pane layout, with contacts on the left and the open chat on the right.

The UI started from a WhatsApp-style layout tutorial. I replaced the hardcoded demo data with Firebase Auth and Firestore, and added the data layer, security rules and tests.

## How it works

```
lib/
  main.dart                  Firebase init, auth gate (signed out -> AuthScreen)
  services/
    auth_service.dart        email sign-in/sign-up, readable error messages
    chat_repository.dart     all Firestore reads and writes
  models/                    ChatUser, Message
  screens/                   auth, mobile list + chat, web two-pane layout
  widgets/                   contact list, message list, input, bubbles
firestore.rules              who can read and write what
```

Firestore layout:

```
users/{uid}                    name, email
chats/{uidA_uidB}              members, lastMessage, updatedAt
chats/{uidA_uidB}/messages/*   senderId, text, sentAt
```

The chat id is the two user ids, sorted and joined. Both people always land on the same document without a lookup, and the security rules can check membership from the id alone. A message and the chat summary are written in one batch, so the summary never points at a message that failed to save.

Rules in short: signed-in users can see the user list but only edit their own profile. Only the two members can read a chat. You can only send messages as yourself, up to 4000 characters, and messages can't be edited or deleted.

## Running it

You need Flutter (stable) and a Firebase project with Email/Password auth and Firestore turned on.

```bash
flutter pub get
flutterfire configure      # points lib/firebase_options.dart at your project
firebase deploy --only firestore:rules
flutter run                # or: flutter run -d chrome
```

## Tests

```bash
flutter test
```

- `chat_repository_test.dart` runs the real repository against an in-memory Firestore (`fake_cloud_firestore`). It checks chat ids, contact lists, sending, ordering and blank-message handling.
- `widgets_test.dart` checks the message input and message list.
- `models_test.dart` covers avatar initials and time formatting.

CI runs `flutter analyze` and `flutter test` on every push.

## What's next

- Show the last message in the contact list (it is already stored in `chats/*`), then unread counts
- Push notifications with Firebase Cloud Messaging
- Image messages via Firebase Storage
