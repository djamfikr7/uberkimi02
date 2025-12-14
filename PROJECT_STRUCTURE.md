# Project Structure

This document describes the clean, organized structure of the Uber Clone project.

## Root Directory

```
uberkimi02/
├── flutter-apps/           # Contains all Flutter applications
├── flutter-packages/       # Contains shared Flutter packages
├── backend-services/       # Contains all backend microservices
├── init-scripts/           # Initialization and setup scripts
└── README.md              # Main project documentation
```

## Flutter Applications

### Rider Application
```
flutter-apps/rider_app/
├── lib/
│   ├── config/            # Environment and configuration
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── services/          # API and business logic
│   ├── theme/             # UI theme and styling
│   └── widgets/           # Reusable UI components
├── pubspec.yaml           # Dependencies
└── README.md              # App-specific documentation
```

### Driver Application
```
flutter-apps/driver_app/
├── lib/
│   ├── config/            # Environment and configuration
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── services/          # API and business logic
│   ├── theme/             # UI theme and styling
│   └── widgets/           # Reusable UI components
├── pubspec.yaml           # Dependencies
└── README.md              # App-specific documentation
```

### Admin Application
```
flutter-apps/admin_app/
├── lib/
│   ├── config/            # Environment and configuration
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── services/          # API and business logic
│   ├── theme/             # UI theme and styling
│   └── widgets/           # Reusable UI components
├── pubspec.yaml           # Dependencies
└── README.md              # App-specific documentation
```

## Shared Packages

### Uber Shared Package
```
flutter-packages/uber_shared/
├── lib/
│   ├── models/            # Shared data models
│   ├── widgets/           # Shared UI components
│   └── utils/             # Shared utility functions
└── pubspec.yaml           # Dependencies
```

## Backend Services

### Rider Service
```
backend-services/rider-service/
├── controllers/           # Request handlers
├── middleware/            # Authentication and validation
├── models/                # Database models
├── routes/                # API route definitions
├── services/              # Business logic
├── utils/                 # Utility functions
├── config/                # Configuration files
├── .env                   # Environment variables
├── server.js              # Main server entry point
└── package.json           # Dependencies
```

### Driver Service
```
backend-services/driver-service/
├── controllers/           # Request handlers
├── middleware/            # Authentication and validation
├── models/                # Database models
├── routes/                # API route definitions
├── services/              # Business logic
├── utils/                 # Utility functions
├── config/                # Configuration files
├── .env                   # Environment variables
├── server.js              # Main server entry point
└── package.json           # Dependencies
```

### Admin Service
```
backend-services/admin-service/
├── controllers/           # Request handlers
├── middleware/            # Authentication and validation
├── models/                # Database models
├── routes/                # API route definitions
├── services/              # Business logic
├── utils/                 # Utility functions
├── config/                # Configuration files
├── .env                   # Environment variables
├── server.js              # Main server entry point
└── package.json           # Dependencies
```

## Key Principles

1. **Separation of Concerns**: Each application and service has a single responsibility
2. **Shared Components**: Common functionality is extracted to the `uber_shared` package
3. **Environment Configuration**: All apps use consistent environment variable patterns
4. **Microservice Architecture**: Backend is split into role-specific services
5. **Clean Dependencies**: Each component manages its own dependencies