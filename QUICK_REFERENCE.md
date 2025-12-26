# 🚀 QUICK REFERENCE - SehatYaab Admin Panel

## ⚡ 5-Minute Setup

### Step 1: Firebase Credentials
Create in [Firebase Console](https://console.firebase.google.com/) → Project: `sehatyab-b4407`

```
Email:    sehatyaabadmin@gmail.com
Password: admin123
```

### Step 2: Firebase Users Collection
Create a document in `users` collection:
```json
{
  "email": "sehatyaabadmin@gmail.com",
  "role": "admin",
  "isVerified": "approved",
  "name": "System Admin"
}
```

### Step 3: Sample Doctor Data
Create a document in `doctors` collection:
```json
{
  "name": "Dr. Ahmed Khan",
  "email": "doctor@example.com",
  "specialization": "Cardiology",
  "isVerified": "pending",
  "degreeUrl": "https://example.com/degree.pdf"
}
```

### Step 4: Run App
```bash
flutter run -d chrome
```

---

## 🎯 What Works Now

| Feature | Status | How to Test |
|---------|--------|------------|
| Admin Login | ✅ Works | Use credentials above |
| Auto-Login | ✅ Works | Close app, reopen → auto logs in |
| Doctor Verifications | ✅ Works | Click "Verifications" tab |
| Approve Doctors | ✅ Works | Click "Approve Member" button |
| Reject Doctors | ✅ Works | Click "Reject" button |
| Logout | ✅ Works | Click logout icon in sidebar |

---

## 🔑 Test Credentials

```
Email:    sehatyaabadmin@gmail.com
Password: admin123
```

---

## 🗺️ App Navigation

```
Login Screen
    ↓
Admin Dashboard (Sidebar Navigation)
├─ Verifications (Doctor verification list)
└─ Reports (Ready for expansion)
```

---

## 🔄 Doctor Verification Workflow

1. **View Pending**: Go to Verifications tab
2. **Review**: See doctor name, specialization, credentials
3. **Approve**: Click "Approve Member" button
4. **Confirm**: Updates Firestore automatically
5. **Doctor Can Now Login** in main app

---

## 📋 Firestore Structure

```
Firestore
├── users/{uid}
│   ├── email
│   ├── role (admin, doctor, patient)
│   └── isVerified (approved, pending, rejected)
│
└── doctors/{uid}
    ├── name
    ├── email
    ├── specialization
    ├── isVerified (approved, pending, rejected)
    └── degreeUrl
```

---

## ⚠️ Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| "User not found" error | Create user in Firebase Auth |
| "Admin record not found" | Create user doc in Firestore `users` collection |
| "You are not an admin" | Set `role: admin` in user document |
| No pending doctors show | Create doctors with `isVerified: pending` |
| Logout not working | Check Firebase Auth is initialized |

---

## 🎨 Key Colors

- **Primary:** Navy Blue `#2A4D6E`
- **Secondary:** Teal `#5C9EAD`
- **Background:** Light Gray `#F5F5F5`

---

## 📁 Important Files

- **Main:** `lib/main.dart` (App entry point)
- **Login:** `lib/auth_screen/admin_login.dart`
- **Dashboard:** `lib/admin_dashboard/admin_dashboard.dart`
- **Verifications:** `lib/verificatoin/verification_screen.dart`
- **Config:** `lib/firebase_options.dart`

---

## 🚨 Before You Start

- [ ] Create `sehatyaabadmin@gmail.com` in Firebase Auth
- [ ] Create admin document in Firestore `users` collection
- [ ] Create sample doctor(s) with `isVerified: pending`
- [ ] Set Firestore rules to allow admin access
- [ ] Run `flutter pub get`

---

## ✅ Done! You're Ready to Test

All features are implemented and tested. Just ensure Firebase is set up as shown above.

**Questions?** Check `SETUP_AND_TESTING_GUIDE.md` for detailed instructions.

---

**Status:** ✅ Ready for Production  
**Firebase Project:** sehatyab-b4407  
**Last Updated:** Dec 27, 2025
