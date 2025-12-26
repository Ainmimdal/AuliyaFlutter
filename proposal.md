# Auliya - Islamic Gamified Habit Tracker for Children
## Hybrid Mobile Application Development Proposal

---

## Group Members
- 2127923 Mohamad Imad Addin Bin Ja'far
- 2219061 SHOPNO MD TANVIR AHMMED

---

## Project Title
**Auliya: Islamic Gamified Star Chart for Building Good Habits in Children**

---

## 1. Introduction

### Problem Statement
In the digital age, parents face increasing challenges in instilling positive Islamic values and good habits in their children. Traditional star charts and reward systems are often static, unmotivating, and difficult to track consistently. Parents need a modern, engaging solution that combines Islamic teachings with gamification to encourage children to develop better character traits (akhlaq) and daily good deeds.

### Motivation
Muslim parents around the world are seeking innovative ways to encourage their children to develop good habits and Islamic values. While traditional star charts exist, there is a gap in the market for a dedicated Islamic-focused, gamified habit tracker that:
- Works seamlessly on both Android and iOS devices
- Combines modern gamification techniques with Islamic teachings
- Provides visual, engaging feedback that motivates children
- Allows parents to customize rewards and track progress
- Offers a Shariah-compliant, family-friendly experience

By developing this application using Flutter, we can:
- Reach both Android and iOS users from a single codebase
- Provide a modern, responsive cross-platform experience
- Implement robust state management and clean architecture
- Create an engaging UI/UX with Flutter's rich widget ecosystem
- Reduce development time and maintenance costs

### Relevance
This project aligns with the **Islamic Da'wah / Community Development** domain by:
- Promoting Islamic values and character development in children
- Encouraging daily prayers, Quranic learning, and good deeds
- Providing Islamic prayers (Doa) as educational content
- Supporting Muslim families in raising righteous children
- Building a Shariah-compliant, ethical application

The application addresses a real need in Muslim communities worldwide and demonstrates practical application of hybrid mobile development principles taught in INFO 4335.

---

## 2. Objectives

1. **Develop a cross-platform mobile application** using Flutter to track children's daily good deeds and habits
2. **Implement a gamification system** with progressive levels, star rewards, and visual feedback to motivate children
3. **Create an intuitive parent dashboard** for managing multiple children's profiles and tracking progress
4. **Integrate Firebase services** for authentication, real-time database, and cloud storage
5. **Design an engaging UI/UX** with animations, Islamic-themed graphics, and child-friendly interfaces
6. **Implement a comprehensive reward system** with daily tasks and ultimate bonus rewards
7. **Provide Islamic educational content** including daily prayers (Dua) for children
8. **Incorporate data visualization** through charts and graphs to display progress over time
9. **Ensure Shariah compliance** in all content, imagery, and functionality

---

## 3. Target Users

### Primary Users
- **Parents** (age 25-45): Muslim parents who want to track and encourage good behavior in their children
  - Tech-savvy parents comfortable with mobile applications
  - Seeking modern tools to supplement traditional Islamic education
  - Managing one or multiple children (ages 3-15)

### Secondary Users
- **Children** (age 3-15): The recipients of the rewards and motivation
  - Visual learners who respond well to gamification
  - Developing Islamic habits and character (akhlaq)
  - Encouraged by visual progress indicators and rewards

### User Personas
1. **Ibu Fatimah** - Mother of 3 children, uses the app daily to track each child's prayers, Quran reading, and household chores
2. **Ustaz Ahmad** - Father and Islamic teacher who uses the app to teach his children about rewards in both dunya and akhirah
3. **8-year-old Aisha** - Loves seeing her rocket progress and earning stars for completing daily prayers

---

## 4. Features and Functionalities

### 4.1 Core Features

#### **User Authentication**
- Google Sign-In integration
- Firebase Authentication
- User profile management with avatar
- Secure logout functionality

#### **Child Profile Management**
- Create multiple child profiles
- Each profile includes:
  - Child's name
  - Date of birth (with age calculation)
  - Profile picture (upload from gallery or camera)
  - Individual progress tracking
- Edit child information
- Delete child profiles with confirmation
- Premium tier: Unlimited children (Free: 1 child only)

#### **Daily Habit Tracking (Akhlaq Harian)**
- Interactive rocket animation showing progress
- 9-level progression system (0-8 levels)
- Tap to increase/decrease daily score
- Visual feedback with:
  - Animated rocket traveling through space
  - Sound effects for good/bad actions
  - Smooth level transitions
- Real-time synchronization with Firebase
- Checkmarks tracking with timestamps

#### **Star Reward System**
- Earn 1 star upon completing all 9 levels
- Star counter displayed prominently
- Stars used as currency for claiming rewards
- Star balance updates in real-time
- Visual celebration animation when earning stars

#### **Daily Rewards (Ganjaran Harian)**
- Parents create custom daily rewards
- Each reward includes:
  - Reward name/description
  - Reward image
  - Star price
- Swipe to delete rewards
- Children can claim rewards when they have enough stars
- Reward claim reduces star balance
- Confirmation dialogs with animations

#### **Ultimate Rewards (Bonus)**
- Higher-value reward tier
- Premium rewards for long-term goals
- Custom images and descriptions
- Higher star prices
- Special unlock animations
- Motivation for sustained good behavior

#### **Islamic Content - Dua Collection**
- Curated collection of essential Islamic prayers:
  - Dua before eating
  - Dua after eating
  - Dua before sleeping
  - Dua upon waking up
- Each Dua includes:
  - Arabic text
  - Romanized transliteration
  - Malay/English translation
- Horizontal scrollable card interface
- Beautiful typography and Islamic design

#### **Progress Analytics**
- Line chart visualization of progress
- Multiple time ranges:
  - Weekly view
  - Monthly view
  - Custom date ranges
- Multi-child comparison
- Track trends over time
- Identify patterns in behavior

#### **Child Selector**
- Discrete horizontal scroll view
- Visual child profile cards
- Quick switching between children
- Smooth animations
- Touch-friendly design

### 4.2 UI/UX Features

#### **Splash Screen**
- Lottie animation on app launch
- Smooth transition to main screen
- Brand identity establishment

#### **Navigation**
- Side drawer navigation menu
- Access to:
  - Main dashboard (child grid)
  - Dua collection
  - Analytics/charts
  - Premium upgrade
  - Sign out
- Contextual toolbars
- Back navigation support

#### **Animations**
- Lottie animations for splash screen
- Rocket progress animation (1401 frames)
- Button press animations (scale down/up)
- Star earning celebration
- Page transitions
- Loading indicators

#### **Premium Paywall**
- Integration with RevenueCat for in-app purchases
- Freemium model (1 child free, unlimited with premium)
- Premium benefits display
- Restore purchases option

#### **Responsive Design**
- Grid layout for child profiles (2 columns)
- Adapts to different screen sizes
- Proper spacing and padding
- Material Design principles

---

## 5. Proposed UI Mock-up

### Screen Flow Overview
```
[Splash Screen]
      ↓
[Google Sign-In] → [Main Dashboard]
                         ↓
            [Child Grid View (2 columns)]
                         ↓
            [Select Child] → [Child Detail (Tabs)]
                                     ↓
                    ┌────────────────┼────────────────┐
                    ↓                ↓                ↓
            [Akhlaq Harian]  [Ganjaran Harian]  [Bonus Rewards]
                 (Tab 1)          (Tab 2)           (Tab 3)
```

### Key Screens Description

#### **1. Splash Screen**
- Centered Lottie rocket animation
- Purple gradient background
- App logo/branding
- Auto-advances to main screen

#### **2. Main Dashboard**
- **Top**: Toolbar with menu icon and sign-out option
- **Background**: Space-themed with stars
- **Content**: 
  - Banner with app branding
  - Grid of child profile cards (2 columns)
  - Each card shows:
    - Circular profile picture
    - Child name
    - Age
    - Star count
    - Current level indicator
- **Bottom**: Floating action button (FAB) to add new child
- **Empty State**: "Tiada Rekod" message when no children

#### **3. Add/Edit Child Dialog**
- Modal dialog overlay
- Input fields:
  - Name (text input)
  - Date of birth (date picker)
  - Profile picture selector
- Camera/gallery image picker
- Save/Cancel buttons
- Rounded corners, purple accent colors

#### **4. Child Detail Screen (3 Tabs)**
**Header Bar:**
- Back button
- Circular child profile picture (70dp)
- Child name (bold, white text)
- Age display
- Star count with star icon
- Edit/Delete menu

**Tab 1 - Akhlaq Harian:**
- Central rocket Lottie animation
- Rocket position indicates current level (0-8)
- Two large buttons:
  - Green "+" button (increase score)
  - Red "-" button (decrease score)
- Button animations on press
- Sound feedback on actions
- Celebration dialog when reaching level 9

**Tab 2 - Ganjaran Harian:**
- Scrollable list of daily rewards
- Each reward card shows:
  - Reward image
  - Reward name
  - Star price
  - Claim button
- Swipe left to delete
- FAB to add new reward
- Dialog to create reward with image upload

**Tab 3 - Bonus:**
- Similar to Tab 2 but for premium rewards
- Larger star prices
- Special unlock animations
- Add bonus dialog with image picker

#### **5. Dua Collection Screen**
- Horizontal discrete scrolling
- Large cards with:
  - Dua title
  - Arabic text (large, right-to-left)
  - Romanized transliteration
  - Translation
- Scale animation on scroll
- Islamic geometric patterns
- Toolbar with back button

#### **6. Analytics/Chart Screen**
- Toolbar with back button
- Child selector (horizontal scroll)
- Date range spinner (weekly/monthly)
- Line chart showing progress
- X-axis: Dates
- Y-axis: Level achieved
- Multiple child comparison option
- Smooth chart animations

#### **7. Premium Paywall**
- Premium feature list
- Pricing display
- Purchase button
- Restore purchases option
- Close button

### Design System

**Colors:**
- Primary: Purple (#673AB7)
- Primary Dark: Deep Purple (#512DA8)
- Accent: Light Purple/Pink
- Background: Dark purple gradient
- Text: White on dark, black on light
- Success: Green
- Error: Red

**Typography:**
- Font Family: Nunito (Bold, ExtraBold)
- Headings: 20-24sp, ExtraBold
- Body: 16sp, Bold
- Captions: 14sp

**Components:**
- Rounded corners (8-16dp border radius)
- Elevated cards with shadows
- Circular profile images with borders
- Material buttons with ripple effects
- Custom button animations

**Icons:**
- Material icons
- Star icon for rewards
- Rocket for progress
- Camera for image upload
- Delete icon for swipe actions

**Animations:**
- Duration: 200-2000ms
- Easing: EaseInOutElastic for charts
- Scale transforms for buttons
- Fade transitions for dialogs

---

## 6. Architecture / Technical Design

### 6.1 Overall Architecture

```
┌─────────────────────────────────────────────────────┐
│                 Presentation Layer                  │
│  (Flutter Widgets - Screens, Dialogs, Components)  │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│              State Management Layer                 │
│         (Provider / Riverpod / Bloc)                │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│               Business Logic Layer                  │
│    (Services, Repositories, Utils, Score Logic)     │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│                  Data Layer                         │
│   (Firebase Auth, Firestore, Storage, RevenueCat)  │
└─────────────────────────────────────────────────────┘
```

### 6.2 Widget/Component Structure

#### **Project Structure**
```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_assets.dart
│   ├── routes/
│   │   └── app_router.dart
│   └── utils/
│       ├── date_util.dart
│       ├── score_util.dart
│       └── validators.dart
│
├── data/
│   ├── models/
│   │   ├── child_model.dart
│   │   ├── reward_model.dart (Harian & Bonus)
│   │   └── dua_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── child_repository.dart
│   │   └── reward_repository.dart
│   └── services/
│       ├── firebase_service.dart
│       ├── storage_service.dart
│       └── purchase_service.dart
│
├── presentation/
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── dashboard/
│   │   │   ├── main_screen.dart
│   │   │   └── widgets/
│   │   │       └── child_card.dart
│   │   ├── child_detail/
│   │   │   ├── child_detail_screen.dart
│   │   │   └── tabs/
│   │   │       ├── akhlaq_tab.dart
│   │   │       ├── ganjaran_tab.dart
│   │   │       └── bonus_tab.dart
│   │   ├── child_setup/
│   │   │   └── child_setup_dialog.dart
│   │   ├── dua/
│   │   │   ├── dua_screen.dart
│   │   │   └── widgets/
│   │   │       └── dua_card.dart
│   │   ├── analytics/
│   │   │   ├── chart_screen.dart
│   │   │   └── widgets/
│   │   │       └── progress_chart.dart
│   │   └── paywall/
│   │       └── paywall_screen.dart
│   │
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── loading_indicator.dart
│   │   ├── reward_card.dart
│   │   └── child_selector.dart
│   │
│   └── providers/
│       ├── auth_provider.dart
│       ├── child_provider.dart
│       ├── reward_provider.dart
│       └── purchase_provider.dart
│
└── firebase_options.dart (generated by FlutterFire CLI)
```

### 6.3 State Management Approach

#### **Recommended: Provider Pattern**

**Why Provider?**
- Native Flutter solution, good for medium complexity
- Easy to learn and implement
- Efficient rebuilds with ChangeNotifier
- Good community support and documentation
- Suitable for team collaboration

**Alternative: Riverpod** (more robust, modern alternative to Provider)

#### **Provider Architecture Example**

```dart
// Child Provider
class ChildProvider extends ChangeNotifier {
  final ChildRepository _repository;
  List<ChildModel> _children = [];
  bool _isLoading = false;
  String? _error;

  List<ChildModel> get children => _children;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChildProvider(this._repository);

  Future<void> fetchChildren() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _children = await _repository.getChildren();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addChild(ChildModel child) async {
    await _repository.createChild(child);
    await fetchChildren();
  }

  Future<void> updateChild(String childId, ChildModel child) async {
    await _repository.updateChild(childId, child);
    await fetchChildren();
  }

  Future<void> deleteChild(String childId) async {
    await _repository.deleteChild(childId);
    await fetchChildren();
  }

  void increaseScore(String childId) {
    final child = _children.firstWhere((c) => c.id == childId);
    if (child.level < 8) {
      child.level++;
      child.checkmarks.add(DateTime.now());
    } else if (child.level == 8) {
      // Level 9 reached - award star
      child.level = 0;
      child.star++;
    }
    _repository.updateChild(childId, child);
    notifyListeners();
  }

  void decreaseScore(String childId) {
    final child = _children.firstWhere((c) => c.id == childId);
    if (child.level > 0) {
      child.level--;
      if (child.checkmarks.isNotEmpty) {
        child.checkmarks.removeLast();
      }
      _repository.updateChild(childId, child);
      notifyListeners();
    }
  }
}

// Usage in Widget
class AkhlaqTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChildProvider>(
      builder: (context, childProvider, child) {
        final currentChild = childProvider.children[currentIndex];
        
        return Column(
          children: [
            // Rocket animation based on currentChild.level
            Lottie.asset('assets/rocket.json'),
            
            // Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => childProvider.increaseScore(currentChild.id),
                  child: Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () => childProvider.decreaseScore(currentChild.id),
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
```

#### **Provider Setup in main.dart**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChildProvider(ChildRepository())),
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

### 6.4 Navigation Strategy

#### **Named Routes with Arguments**

```dart
// routes/app_router.dart
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String childDetail = '/child-detail';
  static const String childSetup = '/child-setup';
  static const String dua = '/dua';
  static const String analytics = '/analytics';
  static const String paywall = '/paywall';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case childDetail:
        final child = settings.arguments as ChildModel;
        return MaterialPageRoute(
          builder: (_) => ChildDetailScreen(child: child),
        );
      // ... other routes
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}

// Usage
Navigator.pushNamed(
  context,
  AppRouter.childDetail,
  arguments: selectedChild,
);
```

### 6.5 Key Technical Components

#### **Score Utility Logic**
```dart
class ScoreUtils {
  static void increaseScore(ChildModel child) {
    child.checkmarks.add(DateTime.now().millisecondsSinceEpoch);
    if (child.level < 8) {
      child.level++;
    } else {
      // Level 8 -> Reset and award star
      child.level = 0;
      child.star++;
      return true; // Indicates star earned
    }
    return false;
  }

  static void decreaseScore(ChildModel child) {
    if (child.level > 0) {
      child.level--;
      if (child.checkmarks.isNotEmpty) {
        child.checkmarks.removeLast();
      }
    }
  }

  static void claimReward(ChildModel child, int rewardPrice) {
    if (child.star >= rewardPrice) {
      child.star -= rewardPrice;
    }
  }
}
```

---

## 7. Data Model

### 7.1 Firestore Database Structure

```
users/
  └── {userId}/
       ├── email: String
       ├── displayName: String
       ├── photoURL: String
       ├── createdAt: Timestamp
       ├── isPremium: Boolean
       │
       └── children/ (subcollection)
            └── {childId}/
                 ├── name: String
                 ├── age: String (format: "DD/MM/YYYY")
                 ├── img: String (Storage URL)
                 ├── level: Number (0-8)
                 ├── hariankey: Number
                 ├── star: Number
                 ├── checkmarks: Array<Timestamp>
                 ├── createdAt: Timestamp
                 ├── updatedAt: Timestamp
                 │
                 ├── harian/ (subcollection - daily rewards)
                 │    └── {rewardId}/
                 │         ├── name: String
                 │         ├── description: String
                 │         ├── imageUrl: String
                 │         ├── price: Number (stars)
                 │         └── createdAt: Timestamp
                 │
                 └── bonus/ (subcollection - ultimate rewards)
                      └── {bonusId}/
                           ├── name: String
                           ├── description: String
                           ├── imageUrl: String
                           ├── price: Number (stars)
                           └── createdAt: Timestamp
```

### 7.2 Entity Relationship Diagram (ERD)

```
┌─────────────────────┐
│       User          │
│─────────────────────│
│ • userId (PK)       │
│ • email             │
│ • displayName       │
│ • photoURL          │
│ • isPremium         │
│ • createdAt         │
└──────────┬──────────┘
           │
           │ 1:N (has many)
           │
┌──────────▼──────────┐
│       Child         │
│─────────────────────│
│ • childId (PK)      │
│ • userId (FK)       │
│ • name              │
│ • age               │
│ • img               │
│ • level             │
│ • hariankey         │
│ • star              │
│ • checkmarks[]      │
│ • createdAt         │
│ • updatedAt         │
└──────────┬──────────┘
           │
           ├──────────────────┐
           │ 1:N              │ 1:N
           │                  │
┌──────────▼──────────┐  ┌───▼──────────────┐
│   HarianReward      │  │   BonusReward    │
│─────────────────────│  │──────────────────│
│ • rewardId (PK)     │  │ • bonusId (PK)   │
│ • childId (FK)      │  │ • childId (FK)   │
│ • name              │  │ • name           │
│ • description       │  │ • description    │
│ • imageUrl          │  │ • imageUrl       │
│ • price             │  │ • price          │
│ • createdAt         │  │ • createdAt      │
└─────────────────────┘  └──────────────────┘
```

### 7.3 Dart Models

#### **Child Model**
```dart
class ChildModel {
  final String id;
  final String userId;
  String name;
  String age; // Format: "DD/MM/YYYY"
  String img;
  int level;
  int hariankey;
  int star;
  List<int> checkmarks; // Timestamps
  DateTime createdAt;
  DateTime updatedAt;

  ChildModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.img,
    this.level = 0,
    this.hariankey = 0,
    this.star = 0,
    List<int>? checkmarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : checkmarks = checkmarks ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Calculate age from birthdate
  int getAgeInYears() {
    final parts = age.split('/');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    
    final birthDate = DateTime(year, month, day);
    final today = DateTime.now();
    
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Factory from Firestore
  factory ChildModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChildModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? '',
      img: data['img'] ?? '',
      level: data['level'] ?? 0,
      hariankey: data['hariankey'] ?? 0,
      star: data['star'] ?? 0,
      checkmarks: List<int>.from(data['checkmarks'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'img': img,
      'level': level,
      'hariankey': hariankey,
      'star': star,
      'checkmarks': checkmarks,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
  }

  ChildModel copyWith({
    String? name,
    String? age,
    String? img,
    int? level,
    int? hariankey,
    int? star,
    List<int>? checkmarks,
  }) {
    return ChildModel(
      id: id,
      userId: userId,
      name: name ?? this.name,
      age: age ?? this.age,
      img: img ?? this.img,
      level: level ?? this.level,
      hariankey: hariankey ?? this.hariankey,
      star: star ?? this.star,
      checkmarks: checkmarks ?? this.checkmarks,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
```

#### **Reward Model (Harian & Bonus)**
```dart
class RewardModel {
  final String id;
  final String childId;
  String name;
  String description;
  String imageUrl;
  int price; // Star cost
  DateTime createdAt;

  RewardModel({
    required this.id,
    required this.childId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RewardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RewardModel(
      id: doc.id,
      childId: data['childId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'childId': childId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
```

#### **Dua Model**
```dart
class DuaModel {
  final int id;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;

  DuaModel({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  // Static list of Duas (can be loaded from JSON or hardcoded)
  static List<DuaModel> getDuaList() {
    return [
      DuaModel(
        id: 1,
        title: "Doa Sebelum Makan",
        arabic: "اَللّٰهُمَّ بَارِكْ لَنَا فِيْمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ",
        transliteration: "Alloohumma barik lanaa fiimaa razatanaa waqinaa 'adzaa bannar",
        translation: "Ya Allah, berkatilah kami dalam rezeki yang telah Engkau berikan kepada kami dan peliharalah kami dari azab api neraka",
      ),
      DuaModel(
        id: 2,
        title: "Doa Selepas Makan",
        arabic: "اَلْحَمْدُ ِللهِ الَّذِىْ اَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِيْنَ",
        transliteration: "Alhamdu lillaahil ladzii ath'amanaa wa saqoonaa wa ja'alnaa muslimiin",
        translation: "Segala puji bagi Allah yang telah memberi makan kami dan minuman kami, serta menjadikan kami sebagai orang-orang islam",
      ),
      DuaModel(
        id: 3,
        title: "Doa Sebelum Tidur",
        arabic: "بِسْمِكَ اللّٰهُمَّ اَحْيَا وَاَمُوْتُ",
        transliteration: "Bismikallohumma ahya wa amuutu",
        translation: "Dengan menyebut nama-Mu ya Allah, aku hidup dan aku mati",
      ),
      DuaModel(
        id: 4,
        title: "Doa Bangun Tidur",
        arabic: "اَلْحَمْدُ ِللهِ الَّذِىْ اَحْيَانَا بَعْدَمَآ اَمَاتَنَا وَاِلَيْهِ النُّشُوْرُ",
        transliteration: "Alhamdu lillahil ladzii ahyaanaa ba'da maa amaa tanaa wa ilahin nusyuuru",
        translation: "Segala puji bagi Allah yang telah menghidupkan kami sesudah kami mati (membangunkan dari tidur) dan hanya kepada-Nya kami dikembalikan",
      ),
    ];
  }
}
```

---

## 8. Flowchart / Sequence Diagram

### 8.1 User Authentication Flow

```
┌─────┐                                    ┌──────────┐                ┌──────────┐
│User │                                    │   App    │                │ Firebase │
└──┬──┘                                    └────┬─────┘                └────┬─────┘
   │                                            │                           │
   │  Launch App                                │                           │
   ├───────────────────────────────────────────>│                           │
   │                                            │                           │
   │                     Display Splash Screen  │                           │
   │<───────────────────────────────────────────┤                           │
   │                                            │                           │
   │                                            │  Check Auth State         │
   │                                            ├──────────────────────────>│
   │                                            │                           │
   │                                            │  Auth State Response      │
   │                                            │<──────────────────────────┤
   │                                            │                           │
   │  [If Not Authenticated]                    │                           │
   │                     Display Login Screen   │                           │
   │<───────────────────────────────────────────┤                           │
   │                                            │                           │
   │  Tap Google Sign-In                        │                           │
   ├───────────────────────────────────────────>│                           │
   │                                            │                           │
   │                                            │  Authenticate with Google │
   │                                            ├──────────────────────────>│
   │                                            │                           │
   │                                            │  Return User Credentials  │
   │                                            │<──────────────────────────┤
   │                                            │                           │
   │                                            │  Identify User (RevenueCat)
   │                                            ├──────────────────────────>│
   │                                            │                           │
   │  [If Authenticated]                        │                           │
   │                  Navigate to Main Dashboard│                           │
   │<───────────────────────────────────────────┤                           │
   │                                            │                           │
```

### 8.2 Child Management Flow

```
┌─────┐                    ┌──────────┐                ┌──────────┐
│User │                    │   App    │                │Firestore │
└──┬──┘                    └────┬─────┘                └────┬─────┘
   │                            │                           │
   │  Tap "Add Child" FAB       │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  Display Add Child Dialog  │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │  Enter Name                │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  Select Date of Birth      │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  Choose/Upload Photo       │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │                            │  Upload Image to Storage  │
   │                            ├──────────────────────────>│
   │                            │                           │
   │                            │  Return Image URL         │
   │                            │<──────────────────────────┤
   │                            │                           │
   │  Tap Save                  │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  [Check Premium Status]    │                           │
   │  If free & has 1 child     │                           │
   │                            │                           │
   │  Show Paywall              │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │  [If Premium or First Child]                           │
   │                            │                           │
   │                            │  Create Child Document    │
   │                            ├──────────────────────────>│
   │                            │                           │
   │                            │  Success                  │
   │                            │<──────────────────────────┤
   │                            │                           │
   │  Show Success & Navigate   │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
```

### 8.3 Daily Habit Tracking (Akhlaq Harian) Flow

```
┌─────┐                    ┌──────────┐                ┌──────────┐
│User │                    │   App    │                │Firestore │
└──┬──┘                    └────┬─────┘                └────┬─────┘
   │                            │                           │
   │  Select Child              │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  Navigate to Child Detail  │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │  View Akhlaq Tab (Default) │                           │
   │                            │                           │
   │                            │  Fetch Child Data         │
   │                            ├──────────────────────────>│
   │                            │                           │
   │                            │  Child Data (level, star) │
   │                            │<──────────────────────────┤
   │                            │                           │
   │  Display Rocket Animation  │                           │
   │  (Position based on level) │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │  Tap "+" Button            │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  [Play Sound Effect]       │                           │
   │  [Animate Button]          │                           │
   │                            │                           │
   │  [Update Local State]      │                           │
   │  - Increment level         │                           │
   │  - Add checkmark timestamp │                           │
   │                            │                           │
   │  [If level reaches 9]      │                           │
   │  - Reset level to 0        │                           │
   │  - Increment star count    │                           │
   │  - Show celebration dialog │                           │
   │                            │                           │
   │  Animate Rocket Movement   │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │                            │  Update Child Document    │
   │                            ├──────────────────────────>│
   │                            │  (level, star, checkmarks)│
   │                            │                           │
   │                            │  Success                  │
   │                            │<──────────────────────────┤
   │                            │                           │
   │  [If Star Earned]          │                           │
   │  Show Celebration Dialog   │                           │
   │<───────────────────────────┤                           │
   │  "Hooray! Anda dapat       │                           │
   │   satu bintang!"           │                           │
   │                            │                           │
   │  Tap OK                    │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  Close Dialog              │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
```

### 8.4 Reward Claiming Flow

```
┌─────┐                    ┌──────────┐                ┌──────────┐
│User │                    │   App    │                │Firestore │
└──┬──┘                    └────┬─────┘                └────┬─────┘
   │                            │                           │
   │  Navigate to Ganjaran Tab  │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │                            │  Fetch Harian Rewards     │
   │                            ├──────────────────────────>│
   │                            │                           │
   │                            │  List of Rewards          │
   │                            │<──────────────────────────┤
   │                            │                           │
   │  Display Reward List       │                           │
   │  (Name, Image, Price)      │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │  Tap "Claim" on Reward     │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  [Validate Star Balance]   │                           │
   │  If stars < price:         │                           │
   │                            │                           │
   │  Show Error Message        │                           │
   │  "Bintang tidak mencukupi" │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │  [If stars >= price]       │                           │
   │                            │                           │
   │  Show Confirmation Dialog  │                           │
   │  "Claim this reward?"      │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
   │  Confirm                   │                           │
   ├───────────────────────────>│                           │
   │                            │                           │
   │  [Update Local State]      │                           │
   │  - Deduct stars            │                           │
   │                            │                           │
   │                            │  Update Child Document    │
   │                            ├──────────────────────────>│
   │                            │  (star count)             │
   │                            │                           │
   │                            │  Success                  │
   │                            │<──────────────────────────┤
   │                            │                           │
   │  Show Success Animation    │                           │
   │  Update Star Display       │                           │
   │<───────────────────────────┤                           │
   │                            │                           │
```

### 8.5 Complete App Navigation Flow

```
                     ┌──────────────┐
                     │Splash Screen │
                     └──────┬───────┘
                            │
                            ▼
                  ┌─────────────────┐
                  │  Check Auth      │
                  └────┬────────┬────┘
                       │        │
               Not Auth│        │Authenticated
                       │        │
                       ▼        ▼
              ┌────────────┐  ┌──────────────┐
              │Login Screen│  │Main Dashboard│
              └─────┬──────┘  └──────┬───────┘
                    │                │
                    │ Sign In        │
                    │                │
                    └────────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
           ┌────────────────┐ ┌───────────┐  ┌──────────────┐
           │Add/Edit Child  │ │Select Child│ │Side Drawer   │
           │    Dialog      │ └─────┬─────┘  └──────┬───────┘
           └────────────────┘       │               │
                                    │               │
                                    ▼               │
                          ┌──────────────────┐      │
                          │Child Detail      │      │
                          │(3 Tabs)          │      │
                          └─────────┬────────┘      │
                                    │               │
                  ┌─────────────────┼─────────────┐ │
                  │                 │             │ │
                  ▼                 ▼             ▼ │
        ┌─────────────────┐ ┌──────────────┐ ┌────────┐
        │Akhlaq Harian    │ │Ganjaran      │ │Bonus   │
        │(Rocket Progress)│ │(Daily Rewards)│ │Rewards │
        └─────────────────┘ └──────────────┘ └────────┘
                                    │
                                    │
           ┌────────────────────────┼────────────────┐
           │                        │                │
           ▼                        ▼                ▼
    ┌───────────┐          ┌────────────┐    ┌──────────┐
    │Dua Screen │          │Analytics/  │    │Paywall   │
    │           │          │Chart Screen│    │Screen    │
    └───────────┘          └────────────┘    └──────────┘
```

---

## 9. Key Packages and Plugins

### 9.1 Firebase & Backend
```yaml
dependencies:
  # Firebase Core
  firebase_core: ^2.24.2
  
  # Firebase Services
  firebase_auth: ^4.15.3
  google_sign_in: ^6.1.6
  firebase_storage: ^11.5.6
  cloud_firestore: ^4.13.6
  firebase_analytics: ^10.7.4
  
  # In-App Purchases
  purchases_flutter: ^6.0.0  # RevenueCat SDK
```

### 9.2 State Management
```yaml
dependencies:
  # Recommended: Provider
  provider: ^6.1.1
  
  # Alternative: Riverpod (more modern)
  # flutter_riverpod: ^2.4.9
  # riverpod_annotation: ^2.3.3
```

### 9.3 UI & Animations
```yaml
dependencies:
  # Animations
  lottie: ^3.0.0
  
  # Image Handling
  cached_network_image: ^3.3.1
  image_picker: ^1.0.7
  
  # Charts
  fl_chart: ^0.66.0  # For analytics charts
  
  # Discrete Scroll (Child Selector)
  carousel_slider: ^4.2.1
  
  # Rounded Images
  flutter_svg: ^2.0.9
```

### 9.4 Utilities
```yaml
dependencies:
  # Date/Time
  intl: ^0.19.0
  
  # File Handling
  path_provider: ^2.1.2
  
  # Permissions
  permission_handler: ^11.2.0
  
  # Loading Indicators
  flutter_spinkit: ^5.2.0
```

### 9.5 Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  
  # Code Generation (if using Riverpod or Freezed)
  build_runner: ^2.4.8
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

---

## 10. Development Phases & Timeline

### Phase 1: Project Setup & Foundation (Week 1)
- [ ] Initialize Flutter project
- [ ] Setup Firebase project and FlutterFire
- [ ] Configure Android & iOS
- [ ] Setup folder structure and architecture
- [ ] Create color scheme and theme
- [ ] Setup routing system

### Phase 2: Authentication & User Management (Week 2)
- [ ] Implement splash screen with Lottie
- [ ] Build login screen with Google Sign-In
- [ ] Setup Firebase Authentication
- [ ] Implement AuthProvider with state management
- [ ] Test authentication flow

### Phase 3: Core Features - Child Management (Week 3)
- [ ] Create main dashboard UI
- [ ] Build child profile card widget
- [ ] Implement add/edit child dialog
- [ ] Setup image picker for profile photos
- [ ] Integrate Firebase Storage for images
- [ ] Implement Firestore CRUD for children
- [ ] Build ChildProvider

### Phase 4: Akhlaq Harian & Scoring System (Week 4)
- [ ] Create child detail screen with tabs
- [ ] Implement rocket Lottie animation
- [ ] Build increase/decrease score buttons
- [ ] Implement score utility logic
- [ ] Add sound effects
- [ ] Create celebration dialog for star earning
- [ ] Real-time Firestore sync

### Phase 5: Reward System (Week 5)
- [ ] Build Ganjaran (Daily Rewards) tab
- [ ] Create reward card component
- [ ] Implement add reward dialog
- [ ] Implement swipe-to-delete functionality
- [ ] Build Bonus rewards tab
- [ ] Implement reward claiming logic
- [ ] Test star deduction

### Phase 6: Islamic Content & Analytics (Week 6)
- [ ] Create Dua collection screen
- [ ] Build horizontal scrollable Dua cards
- [ ] Implement analytics/chart screen
- [ ] Integrate fl_chart for progress visualization
- [ ] Add child selector for multi-child comparison
- [ ] Implement date range filtering

### Phase 7: Premium & Monetization (Week 7)
- [ ] Setup RevenueCat account
- [ ] Implement paywall screen
- [ ] Configure in-app purchases
- [ ] Add premium feature restrictions
- [ ] Test purchase flow (sandbox)

### Phase 8: Polish & Testing (Week 8)
- [ ] UI/UX refinements
- [ ] Add loading states and error handling
- [ ] Optimize performance
- [ ] Test all user flows
- [ ] Fix bugs
- [ ] Prepare for presentation

---

## 11. Shariah-Compliant Considerations

### Ethical Content
✅ **Compliant:**
- Islamic prayers (Dua) with proper translations
- Encouragement of good deeds and character (Akhlaq)
- Halal rewards system
- Family-friendly interface
- Educational Islamic content

❌ **Avoided:**
- No music (only sound effects)
- No inappropriate imagery
- No gambling mechanics
- No misleading practices
- No unethical monetization

### Privacy & Data Protection
- User data stored securely in Firebase
- Minimal data collection (name, email, photos)
- No sharing of children's data with third parties
- Parental control over all content
- Option to delete all data

### Fair Monetization
- Freemium model with generous free tier (1 child)
- No exploitative practices
- Clear pricing
- Restore purchases option
- No forced ads or popups

---

## 12. References

### Flutter Documentation
- [Flutter Official Documentation](https://docs.flutter.dev/)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Firebase Documentation
- [FlutterFire Overview](https://firebase.flutter.dev/)
- [Firebase Authentication](https://firebase.flutter.dev/docs/auth/overview)
- [Cloud Firestore](https://firebase.flutter.dev/docs/firestore/overview)
- [Firebase Storage](https://firebase.flutter.dev/docs/storage/overview)
- [Firebase Analytics](https://firebase.flutter.dev/docs/analytics/overview)

### State Management
- [Provider Package](https://pub.dev/packages/provider)
- [Provider Documentation](https://pub.dev/documentation/provider/latest/)
- [Flutter State Management Guide](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)

### UI/UX Design
- [Material Design 3](https://m3.material.io/)
- [Flutter Material Components](https://docs.flutter.dev/ui/widgets/material)
- [Lottie Animations](https://pub.dev/packages/lottie)
- [FL Chart Documentation](https://pub.dev/packages/fl_chart)

### Packages Used
- [Firebase Core](https://pub.dev/packages/firebase_core)
- [Firebase Auth](https://pub.dev/packages/firebase_auth)
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
- [Firebase Storage](https://pub.dev/packages/firebase_storage)
- [Google Sign In](https://pub.dev/packages/google_sign_in)
- [Image Picker](https://pub.dev/packages/image_picker)
- [Cached Network Image](https://pub.dev/packages/cached_network_image)
- [RevenueCat (Purchases Flutter)](https://pub.dev/packages/purchases_flutter)
- [Intl (Internationalization)](https://pub.dev/packages/intl)

### Islamic Content References
- Authentic Islamic Duas from established sources
- Arabic text verification from Islamic scholars
- Translations reviewed for accuracy

### UI Design Inspiration
- Islamic geometric patterns and calligraphy
- Space/rocket theme for children's engagement
- Child-friendly color psychology (purple, vibrant colors)
- Gamification UI patterns from popular children's apps
- Material Design 3 guidelines

### Best Practices
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Firebase Security Rules Best Practices](https://firebase.google.com/docs/rules/rules-and-auth)
- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 13. Expected Outcomes

Upon completion, this Flutter application will:

1. **Function across platforms**: Work seamlessly on both Android and iOS devices
2. **Engage children**: Use gamification to motivate positive behavior
3. **Empower parents**: Provide tools to track and reward multiple children
4. **Educate**: Include Islamic educational content (Duas)
5. **Scale**: Support growth through premium features
6. **Perform**: Fast, responsive, and reliable
7. **Comply**: Meet all Shariah and ethical standards
8. **Demonstrate mastery**: Showcase INFO 4335 learning outcomes including:
   - Cross-platform hybrid development
   - Firebase integration (Auth, Firestore, Storage)
   - State management (Provider/Riverpod)
   - Complex UI with animations
   - Clean architecture and best practices
   - Real-world problem solving

---

## Conclusion

The Auliya Flutter application represents a comprehensive hybrid mobile solution that addresses a genuine need in Muslim communities while demonstrating advanced technical competencies. By developing this application using Flutter, we achieve cross-platform compatibility, modern architecture, and an engaging user experience.

The project integrates all required components of INFO 4335:
- ✅ Hybrid development with Flutter
- ✅ Firebase services (Auth, Firestore, Storage, Analytics)
- ✅ State management (Provider)
- ✅ Complex UI with animations (Lottie, custom widgets)
- ✅ Forms and user interactions
- ✅ Navigation and routing
- ✅ Packages and plugins
- ✅ Media handling (images)
- ✅ Data visualization (charts)
- ✅ Clean code structure
- ✅ Shariah-compliant content

This proposal serves as our roadmap for developing a meaningful, impactful application that benefits Muslim families worldwide while fulfilling academic requirements.

**Bismillah, let's build something beneficial! 🚀**

---

*End of Proposal*
