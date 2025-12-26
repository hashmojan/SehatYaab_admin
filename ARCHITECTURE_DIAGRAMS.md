# 📊 SehatYaab Admin Panel - Architecture & Flow Diagrams

## 🏗️ Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter App (Web/Desktop)                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │   main.dart     │
                    │                 │
                    │ • Firebase Init │
                    │ • App Setup     │
                    │ • Auth Check    │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────────┐
                    │ AuthCheckScreen     │
                    │                     │
                    │ • Check if logged   │
                    │ • Show loading      │
                    │ • Route to screen   │
                    └────────┬────────────┘
                             │
                    ┌────────┴────────┐
                    ▼                 ▼
        ┌─────────────────────┐   ┌──────────────────────┐
        │ AdminLoginScreen    │   │  AdminDashboard      │
        │                     │   │                      │
        │ • Email input       │   │ • Sidebar nav        │
        │ • Password input    │   │ • Verification list  │
        │ • Login button      │   │ • Reports page       │
        │ • Firebase Auth     │   │ • Logout button      │
        └────────┬────────────┘   └──────────┬───────────┘
                 │                           │
                 │◄──────── Success ─────────┘
                 │
    ┌────────────▼──────────────┐
    │   Firebase Auth           │
    │                           │
    │ • Email/Password auth     │
    │ • Session management      │
    │ • User verification       │
    └────────────┬──────────────┘
                 │
                 ▼
    ┌──────────────────────────┐
    │  Cloud Firestore         │
    │                          │
    │ ┌─────────────────────┐  │
    │ │ users/ (admin data) │  │
    │ ├─────────────────────┤  │
    │ │ • email             │  │
    │ │ • role: 'admin'     │  │
    │ │ • isVerified        │  │
    │ └─────────────────────┘  │
    │                          │
    │ ┌─────────────────────┐  │
    │ │ doctors/ (pending)  │  │
    │ ├─────────────────────┤  │
    │ │ • name              │  │
    │ │ • specialization    │  │
    │ │ • isVerified        │  │
    │ │ • degreeUrl         │  │
    │ └─────────────────────┘  │
    └──────────────────────────┘
```

---

## 🔐 Authentication Flow

```
┌──────────────┐
│ App Launch   │
└──────┬───────┘
       │
       ▼
┌────────────────────────────────┐
│ WidgetsFlutterBinding.init()    │
└────────────┬───────────────────┘
             │
             ▼
┌────────────────────────────────┐
│ Firebase.initializeApp()        │
│ (uses DefaultFirebaseOptions)   │
└────────────┬───────────────────┘
             │
             ▼
┌────────────────────────────────┐
│ AuthCheckScreen                │
│ Calls: autoLoginIfAdmin()      │
└────────────┬───────────────────┘
             │
       ┌─────┴─────┐
       │           │
       ▼           ▼
   ┌─────────┐  ┌────────────────┐
   │ Logged  │  │ Not Logged     │
   │ In?     │  │ (uid==null)    │
   └────┬────┘  └────────┬───────┘
        │                │
        ▼                ▼
   ┌─────────┐  ┌─────────────────┐
   │Dashboard│  │ Login Screen    │
   │ (Auto)  │  │                 │
   └─────────┘  │ Enter:          │
                │ • Email         │
                │ • Password      │
                │                 │
                │ [Login Button]  │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────────┐
                │ Firebase Auth       │
                │ signInWithEmail()   │
                └────────┬────────────┘
                         │
                    ┌────┴────┐
                    ▼         ▼
              Success      Error
                │           │
                ▼           ▼
         ┌──────────────┐ ┌──────────────────┐
         │Check Role in │ │Show Error Msg    │
         │Firestore     │ │Stay on Login     │
         │users/{uid}   │ └──────────────────┘
         └──────┬───────┘
                │
           ┌────┴────┐
           ▼         ▼
      Role==admin   Not Admin
           │         │
           ▼         ▼
       ┌───────┐  ┌──────────┐
       │Dash   │  │Sign Out  │
       │board  │  │Show Error│
       └───────┘  └──────────┘
```

---

## 👨‍⚕️ Doctor Verification Workflow

```
┌────────────────────────────────────────────────────────┐
│       MAIN APP - Doctor Registration                   │
└────────────┬─────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ Doctor submits registration form     │
│ • Name, Email, Phone                │
│ • Specialization, Experience        │
│ • Degree document (PDF)             │
└────────────┬────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────────────┐
│ Create Documents in Firestore                    │
│                                                  │
│ 1. users/{uid}                                  │
│    • email                                       │
│    • role: 'doctor'                             │
│    • isVerified: 'pending' ← KEY                │
│                                                  │
│ 2. doctors/{uid}                                │
│    • name, email, phone                         │
│    • specialization, experience                 │
│    • degreeUrl (Cloud Storage URL)              │
│    • isVerified: 'pending' ← KEY                │
└────────────┬─────────────────────────────────────┘
             │
             │
═════════════ TRANSITION TO ADMIN PANEL ═════════════════
             │
             ▼
┌────────────────────────────────────────────────────────┐
│        ADMIN PANEL - Verification Screen              │
└────────────┬─────────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────────────────────┐
│ StreamBuilder listens to doctors with:                │
│ .where('isVerified', isEqualTo: 'pending')            │
│                                                       │
│ Real-time list of pending verifications             │
└────────────┬─────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────┐
│ Admin reviews doctor credentials                    │
│ • View name, specialization, experience            │
│ • Click "View Degree" to open PDF                  │
└────────────┬────────────────────────────────────────┘
             │
        ┌────┴─────────┐
        ▼              ▼
   ┌─────────┐    ┌──────────┐
   │ Approve │    │ Reject   │
   └────┬────┘    └────┬─────┘
        │              │
        ▼              ▼
   ┌──────────────────────────────┐
   │ Firebase Batch Update:       │
   │                              │
   │ 1. doctors/{uid}             │
   │    isVerified: 'approved'    │ (or 'rejected')
   │                              │
   │ 2. users/{uid}               │
   │    isVerified: 'approved'    │ (or 'rejected')
   └──────────┬───────────────────┘
              │
              ▼
   ┌─────────────────────────────┐
   │ StreamBuilder detects change│
   │ UI updates automatically    │
   │ Show success snackbar       │
   └──────────┬──────────────────┘
              │
═════════════ TRANSITION TO MAIN APP ══════════════════════
              │
              ▼
┌────────────────────────────────────────────────────────┐
│        MAIN APP - Doctor Login                        │
└────────────┬─────────────────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────────────────┐
│ Doctor enters login credentials                     │
│                                                    │
│ System checks: users/{uid}.isVerified              │
│                                                    │
│ ┌────────────────┐        ┌──────────────────────┐│
│ │ == 'approved'  │        │ == 'pending/rejected'││
│ └────────┬───────┘        └──────────┬───────────┘│
│          ▼                            ▼            │
│      Login OK                   Login Denied      │
│      Doctor can access         Doctor must wait  │
│      patient consultation      for approval      │
└──────────────────────────────────────────────────────┘
```

---

## 📊 State Management Flow (GetX)

```
┌──────────────────────────────────┐
│ AdminLoginViewModel              │
│ (GetxController)                 │
│                                  │
│ Properties:                      │
│ • isLoading: RxBool              │
│                                  │
│ Methods:                         │
│ • loginAdmin(email, password)   │
│ • autoLoginIfAdmin()             │
└───────────────────────────────────┘
             │
             │ Get.put()
             ▼
┌────────────────────────────────┐
│ GetX Service Locator            │
│ (Dependency Injection)          │
│                                 │
│ Manages:                        │
│ • ViewModel instances           │
│ • Reactive state                │
│ • Navigation                    │
└────────────────────────────────┘
             │
             │
    ┌────────┴─────────┐
    ▼                  ▼
┌──────────────┐  ┌─────────────┐
│ LoginScreen  │  │ Dashboard   │
│ Observes:    │  │ Observes:   │
│ • isLoading  │  │ • (none)    │
│              │  │             │
│ Updates UI   │  │ Has access  │
│ when state   │  │ to auth     │
│ changes      │  │ services    │
└──────────────┘  └─────────────┘
```

---

## 🔄 Real-time Data Sync Flow

```
┌──────────────────────────────────┐
│ Firestore Database               │
│ (doctors collection)             │
│ with: isVerified='pending'       │
└──────────┬───────────────────────┘
           │
           │ StreamBuilder.stream
           │ .where('isVerified'...)
           │ .snapshots()
           │
           ▼
┌──────────────────────────────────┐
│ Firestore Listener               │
│ (Real-time Updates)              │
└──────────┬───────────────────────┘
           │
           │ OnData / OnError
           │
           ▼
┌──────────────────────────────────┐
│ VerificationScreen               │
│ (UI Updates)                     │
│                                  │
│ Displays:                        │
│ • Doctor name, credentials       │
│ • Approve/Reject buttons         │
│ • View degree link               │
└──────────┬───────────────────────┘
           │
           │ User clicks button
           │
           ▼
┌──────────────────────────────────┐
│ _updateStatus() method           │
│                                  │
│ • Creates WriteBatch             │
│ • Updates doctors/{uid}          │
│ • Updates users/{uid}            │
│ • Commits to Firestore           │
└──────────┬───────────────────────┘
           │
           │ Firestore updates
           │ Listener detects change
           │
           ▼
┌──────────────────────────────────┐
│ UI Refreshes Automatically       │
│                                  │
│ • Removes approved doctor        │
│ • Shows success message          │
│ • Updates list in real-time      │
└──────────────────────────────────┘
```

---

## 🎯 Component Relationship Map

```
main.dart
├── AuthCheckScreen
│   └── Checks auto-login
│       ├─→ AdminLoginScreen (if not logged)
│       └─→ AdminDashboard (if logged)
│
├── AdminLoginScreen
│   ├── EmailTextField
│   ├── PasswordTextField
│   ├── RoundButton (Login)
│   └── AdminLoginViewModel
│       └── Firebase Auth
│           └── Firestore (users collection)
│
└── AdminDashboard
    ├── NavigationRail
    │   ├── Verifications (selected)
    │   ├── Reports
    │   └── LogoutButton
    │       └── AdminLoginViewModel.signOut()
    │
    ├── VerificationScreen
    │   ├── StreamBuilder
    │   │   └── Firestore (doctors.where(isVerified==pending))
    │   ├── DoctorCard
    │   │   ├── Name, Specialization
    │   │   ├── ViewDegreeButton
    │   │   ├── ApproveButton
    │   │   └── RejectButton
    │   │
    │   └── _updateStatus()
    │       └── WriteBatch update (both collections)
    │
    └── ReportsScreen
        └── (Placeholder for expansion)

Components:
├── AppColors (color constants)
├── RoundButton (reusable button)
└── round_button.dart (styling)
```

---

## 🔐 Firebase Security Model

```
┌─────────────────────────────────────────┐
│      Firebase Authentication             │
│                                          │
│  Admin User:                            │
│  ├── Email: sehatyaabadmin@gmail.com   │
│  ├── Password: admin123 (hashed)        │
│  ├── UID: (auto-generated)              │
│  └── Email Verified: ✅                 │
└────────────────┬────────────────────────┘
                 │
                 │ UID Reference
                 ▼
┌─────────────────────────────────────────┐
│      Cloud Firestore Rules               │
│                                          │
│  if (user is authenticated AND           │
│      user.role == 'admin')              │
│  {                                       │
│    allow read: all collections          │
│    allow write: doctors, users          │
│  }                                       │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│    Firestore Collections                │
│                                          │
│  ✅ Full access for admin               │
│  ❌ Limited access for others           │
└─────────────────────────────────────────┘
```

---

## 📈 Session Lifecycle

```
START
  │
  ├─→ App Launches
  │   └─→ Firebase Initialized
  │       └─→ AuthCheckScreen Shows Loading
  │           │
  │           ├─→ autoLoginIfAdmin() checks
  │           │   current user
  │           │
  │           ├─→ User exists?
  │           │   ├─→ Yes: Role==admin?
  │           │   │   ├─→ Yes: Navigate to Dashboard
  │           │   │   └─→ No: Sign out → Login Screen
  │           │   └─→ No: Show Login Screen
  │           │
  │           └─→ UI Rendered
  │
  ├─→ During Usage
  │   ├─→ Token auto-refreshed by Firebase
  │   ├─→ User is logged in continuously
  │   └─→ Can access all features
  │
  └─→ Logout Triggered
      ├─→ Show Confirmation Dialog
      ├─→ User Confirms
      ├─→ Firebase.signOut() called
      ├─→ Local cache cleared
      ├─→ Get.offAll() navigates to Login
      └─→ Session Ended

END
```

---

**Diagrams Updated:** December 27, 2025  
**Status:** ✅ Complete and Accurate
