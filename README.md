# Together List 💑
### A Production-Ready iOS Couples Bucket List App

## 📱 Overview

Together List is a native iOS application that allows couples to create shared bucket lists, track activities, capture memories with photos, and grow together through gamification and achievements.

## ✨ Features

### Core Functionality
- **👥 Partner Connection**: Unique 6-character codes for easy pairing
- **📝 Shared Bucket Lists**: Both partners can add and manage activities
- **📸 Photo Memories**: Capture and attach photos to completed activities
- **🏆 Achievements & Gamification**: Unlock achievements and track streaks
- **☁️ Real-time Sync**: CloudKit integration for seamless synchronization
- **🔔 Smart Notifications**: Activity updates and daily reminders

### Technical Features
- **SwiftUI & UIKit**: Modern iOS development with SwiftUI
- **Core Data + CloudKit**: Local persistence with cloud sync
- **MVVM Architecture**: Clean, maintainable code structure
- **iOS 16+**: Latest iOS features and design patterns
- **Dark Mode**: Full dark mode support
- **Accessibility**: VoiceOver and Dynamic Type support

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 16.0+ deployment target
- Apple Developer Account (for CloudKit)
- macOS Ventura or later

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/TogetherList.git
   cd TogetherList
   ```

2. **Open in Xcode**
   ```bash
   open TogetherList.xcodeproj
   ```

3. **Configure Signing & Capabilities**
   - Select the project in Xcode
   - Go to "Signing & Capabilities"
   - Add your Apple Developer Team
   - Update Bundle Identifier to match your team

4. **Enable CloudKit**
   - In Capabilities, add "CloudKit"
   - Create a new CloudKit container
   - Name it: `iCloud.com.yourcompany.TogetherList`

5. **Configure App Groups**
   - Add "App Groups" capability
   - Create group: `group.com.yourcompany.TogetherList`

6. **Build and Run**
   - Select your target device/simulator
   - Press Cmd+R to build and run

## 📂 Project Structure

```
TogetherList/
├── App/
│   └── TogetherListApp.swift
├── Models/
│   ├── CoreData/
│   │   └── TogetherList.xcdatamodeld
│   ├── DataController.swift
│   ├── UserSettings.swift
│   └── Enums.swift
├── Views/
│   ├── Onboarding/
│   ├── Main/
│   ├── Activities/
│   └── Components/
├── Services/
│   ├── CloudKitManager.swift
│   ├── NotificationManager.swift
│   └── PhotoManager.swift
└── Resources/
    └── Info.plist
```

## 🔧 Configuration

### CloudKit Schema

Create the following record types in CloudKit Dashboard:

#### User Record
- `userID` (String)
- `userName` (String)
- `connectionCode` (String)
- `profileImage` (Asset)

#### Connection Record
- `user1ID` (String)
- `user2ID` (String)
- `connectedDate` (Date)

#### Activity Record (handled by Core Data + CloudKit)
- Automatically synced via NSPersistentCloudKitContainer

### Push Notifications

1. Enable Push Notifications in Capabilities
2. Configure APNs in Apple Developer Portal
3. Upload APNs certificates to your server (if using custom backend)

## 🎨 Customization

### Colors & Themes
Edit `Extensions/Theme.swift` to customize:
- Primary colors
- Accent colors
- Category colors
- Dark mode variants

### Categories
Modify `Models/Enums.swift` to add/remove activity categories

### Achievements
Update `DataController.swift` to customize achievement milestones

## 📊 Database Schema

### Activity Entity
- `id`: UUID
- `title`: String
- `description`: String
- `category`: String
- `priority`: String
- `status`: String
- `createdDate`: Date
- `completedDate`: Date?
- `notes`: String?
- `photos`: Relationship to Photo

### Photo Entity
- `id`: UUID
- `imageData`: Binary
- `caption`: String?
- `takenDate`: Date
- `activity`: Relationship to Activity

## 🧪 Testing

### Unit Tests
```bash
cmd+U # Run all tests
```

### UI Tests
Located in `TogetherListUITests/`

### TestFlight
1. Archive the app (Product → Archive)
2. Upload to App Store Connect
3. Distribute via TestFlight

## 📦 Dependencies

This app uses only native iOS frameworks:
- SwiftUI
- UIKit
- Core Data
- CloudKit
- PhotosUI
- UserNotifications
- Combine

## 🚢 Deployment

### App Store Preparation

1. **App Store Connect**
   - Create app record
   - Add app description and keywords
   - Upload screenshots for all device sizes
   - Set pricing (Free)

2. **Screenshots Required**
   - iPhone 14 Pro Max (6.7")
   - iPhone 14 Pro (6.1")
   - iPhone SE (5.5")
   - iPad Pro (12.9")

3. **App Review Information**
   - Demo account credentials
   - Notes about partner connection feature

### Version Management
- Use semantic versioning (1.0.0)
- Update version in Info.plist
- Tag releases in Git

## 🔐 Privacy & Security

- All data encrypted at rest via Core Data
- CloudKit handles secure cloud sync
- No third-party analytics or tracking
- Photos stored locally with option to save to library
- Connection codes are one-way (can't reverse engineer)

## 📈 Analytics & Monitoring

### Recommended Tools
- App Store Connect Analytics
- Crashlytics (optional)
- CloudKit Dashboard for sync monitoring

## 🐛 Troubleshooting

### Common Issues

**CloudKit Sync Not Working**
- Verify iCloud is signed in on device
- Check CloudKit container configuration
- Ensure network connectivity

**Photos Not Saving**
- Check photo library permissions
- Verify sufficient storage space

**Partner Connection Failed**
- Ensure both users have the app installed
- Verify connection codes are entered correctly
- Check CloudKit public database permissions

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details

## 👥 Support

- Email: support@togetherlist.app
- Twitter: @TogetherListApp
- Website: https://togetherlist.app

## 🎯 Roadmap

### Version 1.1
- [ ] Widget support
- [ ] Apple Watch app
- [ ] Siri shortcuts

### Version 1.2
- [ ] AI-powered activity suggestions
- [ ] Social sharing features
- [ ] Activity templates

### Version 2.0
- [ ] Group activities (double dates)
- [ ] Location-based reminders
- [ ] Video memories

## 🙏 Acknowledgments

- Apple Human Interface Guidelines
- SwiftUI community
- Beta testers and early adopters

---

**Built with ❤️ for couples everywhere**