# Firebase Setup Checklist for SehatYaab Admin Panel

## ✅ Prerequisites Before Running the App

### 1. Create Admin User in Firebase
You need to create an admin account in Firebase Authentication with these exact credentials:

**Email:** `sehatyaabadmin@gmail.com`  
**Password:** `admin123`

**Steps:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `sehatyab-b4407`
3. Navigate to **Authentication** → **Users** tab
4. Click **Add User**
5. Enter the credentials above
6. Create the user

### 2. Create Admin User Document in Firestore
After creating the auth user, you need a document in the Firestore `users` collection.

**Steps:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Navigate to **Cloud Firestore**
3. Create/Edit Collection: `users`
4. Add a new document with:
   - **Document ID:** Use the UID from the created auth user (copy from Authentication → Users)
   - **Fields:**
     - `email` (string): `sehatyaabadmin@gmail.com`
     - `role` (string): `admin`
     - `isVerified` (string): `approved`
     - `name` (string): `System Admin` (optional)
     - `createdAt` (timestamp): current date/time (optional)

**Example Document:**
```json
{
  "email": "sehatyaabadmin@gmail.com",
  "role": "admin",
  "isVerified": "approved",
  "name": "System Admin",
  "createdAt": Timestamp(2024-12-27T00:00:00Z)
}
```

### 3. Verify Firestore Rules
Make sure your Firestore security rules allow the admin to access verification data.

**Basic Rules (for testing - enhance for production):**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow admins to read/write everything
    match /{document=**} {
      allow read, write: if request.auth.uid != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Allow users to read their own document
    match /users/{uid} {
      allow read: if request.auth.uid == uid;
    }
    
    // Allow doctors to read their own document
    match /doctors/{uid} {
      allow read: if request.auth.uid == uid;
    }
  }
}
```

### 4. Sample Doctor Data for Testing
Create some sample doctors with `isVerified: 'pending'` to test the verification system.

**Steps:**
1. Create Collection: `doctors` (if not exists)
2. Add a new document with:
   ```json
   {
     "name": "Dr. Ahmed Khan",
     "email": "ahmed@example.com",
     "phone": "+92-300-1234567",
     "specialization": "Cardiology",
     "experience": 5,
     "isVerified": "pending",
     "degreeUrl": "https://example.com/degree.pdf",
     "createdAt": Timestamp(2024-12-27T00:00:00Z)
   }
   ```
3. Repeat for 2-3 more doctors with different specializations

### 5. Create Corresponding User Documents for Doctors
For each doctor, create a user document as well.

**Steps:**
1. In the `users` collection
2. Add document with same UID as the doctor document
3. Fields:
   ```json
   {
     "email": "doctor_email@example.com",
     "role": "doctor",
     "isVerified": "pending",
     "name": "Doctor Name",
     "uid": "doctor_uid"
   }
   ```

---

## 🔑 Firebase Configuration Currently Set
Your app is configured with:

- **API Key:** `AIzaSyDci3iABnbtM5IpOKokneDnlWdVlXxRjDs`
- **Project ID:** `sehatyab-b4407`
- **Auth Domain:** `sehatyab-b4407.firebaseapp.com`
- **Storage Bucket:** `sehatyab-b4407.firebasestorage.app`
- **Messaging Sender ID:** `334202558492`
- **App ID:** `1:334202558492:web:fadb6269eb8400f9d8e7d9`
- **Measurement ID:** `G-3MG2TF2R8Y`

*(These are automatically loaded from `firebase_options.dart`)*

---

## 🚨 Important Notes

### For Web/Development:
- Firestore Rules should allow broad access for testing
- Consider using Emulator for local development

### For Production:
- ⚠️ **NEVER** commit credentials to version control
- Use Environment variables for sensitive data
- Implement strict Firestore Security Rules
- Enable Email Verification for all admins
- Use strong passwords (not `admin123`)
- Enable Multi-Factor Authentication (MFA)
- Regularly audit admin access logs

---

## 🧪 Testing Checklist

- [ ] Admin user created in Firebase Auth
- [ ] Admin user document exists in Firestore with `role: admin`
- [ ] Sample doctor documents created with `isVerified: pending`
- [ ] Doctor user documents created in `users` collection
- [ ] Firebase Rules allow admin to read/write
- [ ] App runs without errors: `flutter run -d chrome`
- [ ] Can login with `sehatyaabadmin@gmail.com` / `admin123`
- [ ] Can see pending doctor verifications
- [ ] Can approve/reject doctors
- [ ] Firestore updates when verification status changes
- [ ] Auto-login works when app is relaunched
- [ ] Logout clears session and returns to login
- [ ] Error messages display correctly

---

## 📞 Common Firebase Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `FirebaseAuthException: INVALID_LOGIN_CREDENTIALS` | Wrong email/password | Check Firebase console for user credentials |
| `FirebaseAuthException: USER_NOT_FOUND` | User doesn't exist | Create user in Firebase Authentication |
| `Exception: Admin record not found` | No user document in Firestore | Create user document in `users` collection |
| `Exception: You are not an admin` | User doesn't have `role: admin` | Update user document `role` field to `admin` |
| `Missing or insufficient permissions` | Firestore rules deny access | Update Firestore security rules |

---

**Last Updated:** December 27, 2025  
**Firebase Project:** `sehatyab-b4407`
