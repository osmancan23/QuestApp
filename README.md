# QuestApp - Social Media Application

QuestApp is a social media application where users can share posts, interact through comments, and engage with likes.

## Features

- User authentication and authorization
- Post creation with text and image support
- Comment system
- Like/Unlike functionality
- User profiles with statistics
- Detailed post views
- JWT-based session management
- Real-time error handling
- Automatic login redirect on session expiry

## Technology Stack

### Backend (Java Spring Boot)

- **Spring Boot 3.x**: Modern Java framework for building robust applications
- **Spring Security**: Advanced authentication and authorization
- **JWT (JSON Web Tokens)**: Secure session management and stateless authentication
- **MySQL Database**: Reliable data persistence
- **JPA/Hibernate**: ORM for database operations
- **Maven**: Dependency management and build automation
- **RESTful Architecture**: Well-structured API endpoints
- **Multipart File Upload**: Image handling capabilities
- **Custom Exception Handling**: Robust error management
- **Repository Pattern**: Clean data access layer
- **Service Layer Pattern**: Business logic encapsulation
- **DTO Pattern**: Efficient data transfer objects

### Mobile (iOS - SwiftUI)

- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns
  - Models: Data structures and business logic
  - Views: UI components and layouts
  - ViewModels: State management and business logic
- **Combine Framework**: Reactive programming and data binding
- **Network Layer**:
  - Custom NetworkManager for API communication
  - Generic request/response handling
  - Automatic error handling
  - JWT token management
- **Security Features**:
  - Keychain for secure token storage
  - Automatic session management
  - Secure authentication flow
- **Navigation**:
  - Custom router implementation
  - Deep linking support
  - Tab-based navigation
- **Custom Components**:
  - Reusable UI components
  - Image picker and handling
  - Loading states
  - Error handling views
- **Data Persistence**:
  - UserDefaults for user preferences
  - Keychain for sensitive data
- **Async/Await**: Modern concurrency handling

## Setup and Installation

### Backend Setup

1. Install and configure MySQL database
2. Configure database connection in `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/quest_db
spring.datasource.username=your_username
spring.datasource.password=your_password
```

3. Run the following commands:
```bash
cd backend
./mvnw clean install
./mvnw spring-boot:run
```

The backend server will start on `http://localhost:8080`

### iOS Application Setup

1. Open Xcode 15 or later
2. Navigate to `mobile/QuestApp` directory
3. Open `QuestApp.xcodeproj`
4. Select your target iOS simulator (iOS 15.0+)
5. Build and run the project

## API Documentation

The complete API documentation is available in the Postman collection. The collection includes:

- Authentication endpoints (login/register)
- User management
- Post operations
- Comment functionality
- Like system
- File upload endpoints

Import `QuestApp.postman_collection.json` to view and test all available endpoints.

## Project Structure

### Backend Structure
```
backend/
├── src/main/java/
│   ├── controllers/    # REST API endpoints
│   ├── entities/       # Database models
│   ├── repositories/   # Data access layer
│   ├── services/       # Business logic
│   ├── security/       # JWT and authentication
│   ├── requests/       # Request DTOs
│   └── responses/      # Response DTOs
```

### iOS Structure
```
mobile/QuestApp/
├── Core/
│   ├── Network/       # API communication
│   ├── Models/        # Data models
│   ├── Services/      # Business logic
│   └── Components/    # Reusable UI components
├── Features/
│   ├── Auth/         # Login/Register
│   ├── Feed/         # Main feed
│   ├── Profile/      # User profile
│   └── Post/         # Post creation/detail
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 