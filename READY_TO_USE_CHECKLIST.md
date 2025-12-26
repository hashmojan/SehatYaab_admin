# ✅ READY-TO-USE CHECKLIST

Print this out or check off as you go!

---

## 📋 PRE-SETUP CHECKLIST

- [ ] Downloaded the SehatYaab Admin Panel code
- [ ] Have access to Firebase Console (sehatyab-b4407)
- [ ] Flutter is installed and updated
- [ ] Time: ~30 minutes available for setup

---

## 🔧 FIREBASE SETUP (10 minutes)

### Authentication Setup
- [ ] Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] Project: `sehatyab-b4407`
- [ ] Click **Authentication** → **Users** tab
- [ ] Click **Add User**
- [ ] Email: `sehatyaabadmin@gmail.com`
- [ ] Password: `admin123`
- [ ] Create User
- [ ] **Copy the UID** (save it!)

### Firestore User Document Setup
- [ ] Go to **Cloud Firestore**
- [ ] Create collection: `users` (if not exists)
- [ ] Click **Add Document**
- [ ] Document ID: **Paste the UID from above**
- [ ] Add fields:
  - [ ] `email`: `sehatyaabadmin@gmail.com`
  - [ ] `role`: `admin`
  - [ ] `isVerified`: `approved`
  - [ ] `name`: `System Admin` (optional)
- [ ] Save Document

### Create Sample Doctors (for testing)
- [ ] Go to `doctors` collection (create if needed)
- [ ] Create 2-3 sample doctors with:
  - [ ] `name`: Doctor Name
  - [ ] `email`: doctor@example.com
  - [ ] `specialization`: Cardiology (or other)
  - [ ] `isVerified`: `pending` ⚠️ **IMPORTANT**
  - [ ] `degreeUrl`: https://example.com/degree.pdf

### Create Doctor User Documents
- [ ] For each doctor, create in `users` collection:
  - [ ] Document ID: Same UID as doctor document
  - [ ] `email`: doctor email
  - [ ] `role`: `doctor`
  - [ ] `isVerified`: `pending`
  - [ ] `name`: Doctor Name

### Verify Firestore Rules
- [ ] Go to **Firestore** → **Rules** tab
- [ ] Rules allow admin read/write access
- [ ] (See FIREBASE_SETUP_CHECKLIST.md for rules template)

---

## 💻 APP SETUP (5 minutes)

- [ ] Open project in VS Code
- [ ] Open terminal
- [ ] Run: `flutter pub get`
- [ ] Wait for dependencies to install
- [ ] No errors? ✅

---

## 🚀 RUNNING THE APP (5 minutes)

- [ ] Terminal is ready
- [ ] Run: `flutter run -d chrome` (for web)
  - OR: `flutter run -d windows` (for Windows)
- [ ] App launches in browser/window
- [ ] See login screen?
- [ ] Firebase initialized? (No errors in console)

---

## 🧪 TESTING (10 minutes)

### Test 1: Admin Login
- [ ] See login screen
- [ ] Email field: `sehatyaabadmin@gmail.com`
- [ ] Password field: `admin123`
- [ ] Click **Login to Dashboard**
- [ ] **Expected:** Dashboard appears
- [ ] **Actual:** ________________

### Test 2: See Dashboard
- [ ] Dashboard loads without errors
- [ ] See sidebar with "Verifications" and "Reports"
- [ ] See admin name in top right
- [ ] See logout button (⤵️ icon)
- [ ] **Status:** ✅ PASS / ❌ FAIL

### Test 3: Doctor Verifications
- [ ] Click "Verifications" tab
- [ ] See pending doctors from Firestore
- [ ] Each doctor shows: Name, Specialization
- [ ] See buttons: "View Degree", "Approve Member", "Reject"
- [ ] **Status:** ✅ PASS / ❌ FAIL

### Test 4: Approve Doctor
- [ ] Click "Approve Member" button
- [ ] See success message
- [ ] Check Firestore console:
  - [ ] `doctors/{uid}.isVerified` = `approved`
  - [ ] `users/{uid}.isVerified` = `approved`
- [ ] Doctor disappears from pending list
- [ ] **Status:** ✅ PASS / ❌ FAIL

### Test 5: Reject Doctor
- [ ] (Add another pending doctor)
- [ ] Click "Reject" button
- [ ] See success message
- [ ] Check Firestore:
  - [ ] `doctors/{uid}.isVerified` = `rejected`
  - [ ] `users/{uid}.isVerified` = `rejected`
- [ ] Doctor disappears from list
- [ ] **Status:** ✅ PASS / ❌ FAIL

### Test 6: Auto-Login
- [ ] Close the app/browser tab
- [ ] Reopen: `flutter run -d chrome`
- [ ] **Expected:** Directly see Dashboard
- [ ] **Actual:** ________________
- [ ] **Status:** ✅ PASS / ❌ FAIL

### Test 7: Logout
- [ ] Click logout button (⤵️) in sidebar
- [ ] See confirmation dialog
- [ ] Click "Logout"
- [ ] **Expected:** Back to login screen
- [ ] **Actual:** ________________
- [ ] **Status:** ✅ PASS / ❌ FAIL

### Test 8: Login Again
- [ ] On login screen now
- [ ] Enter credentials again
- [ ] Login successfully
- [ ] See dashboard
- [ ] **Status:** ✅ PASS / ❌ FAIL

---

## 🎯 OVERALL TEST RESULTS

| Test | Status | Notes |
|------|--------|-------|
| 1. Login | ✅/❌ | |
| 2. Dashboard | ✅/❌ | |
| 3. See Doctors | ✅/❌ | |
| 4. Approve | ✅/❌ | |
| 5. Reject | ✅/❌ | |
| 6. Auto-Login | ✅/❌ | |
| 7. Logout | ✅/❌ | |
| 8. Login Again | ✅/❌ | |

**Overall:** ✅ ALL PASS / ❌ NEEDS FIXES

---

## 🐛 IF TESTS FAIL

| Issue | Solution |
|-------|----------|
| Login fails | Check FIREBASE_SETUP_CHECKLIST.md |
| Can't see doctors | Verify sample doctors created with `isVerified: pending` |
| Approve doesn't work | Check Firestore Rules allow updates |
| Auto-login doesn't work | Check browser localStorage isn't cleared |
| App won't start | Run `flutter pub get` again |

---

## 📚 DOCUMENTATION REFERENCE

- 🚀 **Quick Setup:** QUICK_REFERENCE.md
- 🔐 **Firebase Help:** FIREBASE_SETUP_CHECKLIST.md
- 🧪 **Testing Help:** SETUP_AND_TESTING_GUIDE.md
- 📋 **How It Works:** IMPLEMENTATION_SUMMARY.md
- 📊 **Diagrams:** ARCHITECTURE_DIAGRAMS.md
- 📖 **All Docs:** DOCUMENTATION_INDEX.md

---

## 🎊 SUCCESS!

If all tests pass:
- [ ] Admin panel is working
- [ ] Login is functional
- [ ] Doctor verification works
- [ ] Auto-login works
- [ ] Logout works
- [ ] **Ready for production!**

---

## 🚀 DEPLOYMENT STEPS

- [ ] All tests pass
- [ ] No errors in console
- [ ] Firebase rules configured
- [ ] Ready to deploy to web hosting
- [ ] Setup CI/CD pipeline (optional)
- [ ] Configure domain name (optional)

---

## 💾 IMPORTANT FILES TO BACKUP

- [ ] `lib/main.dart`
- [ ] `lib/firebase_options.dart`
- [ ] `pubspec.yaml`
- [ ] All documentation files
- [ ] `.env` file (if using environment variables)

---

## 📞 TROUBLESHOOTING QUICK ACCESS

**Problem: "User not found"**
→ Did you create the admin user in Firebase Auth? Check step 1

**Problem: "Admin record not found"**
→ Did you create the admin document in Firestore users collection? Check step 2

**Problem: "You are not an admin"**
→ Is the user document's `role` field set to `admin`? Check step 2

**Problem: No pending doctors showing**
→ Did you create sample doctors with `isVerified: pending`? Check step 3

**Problem: App won't start**
→ Run `flutter pub get` and check for errors

**Problem: Firebase not initializing**
→ Check Firebase project ID matches `sehatyab-b4407`

---

## ✨ YOU'RE ALL SET!

Follow this checklist and your admin panel will be:
- ✅ Setup correctly
- ✅ Fully tested
- ✅ Ready to use
- ✅ Production ready

---

## 📋 SIGN-OFF

- [ ] I have completed all setup steps
- [ ] I have tested all features
- [ ] Everything is working
- [ ] I understand the system
- [ ] I'm ready to use it

**Date Completed:** _______________

**Signed:** _______________

---

**Good luck! Your SehatYaab Admin Panel is ready! 🚀**
