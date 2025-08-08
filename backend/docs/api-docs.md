# API Documentation

## Overview

This document provides an overview of the API endpoints available in the Instagram Clone application. The API follows RESTful principles and uses JSON for request and response payloads.

## Base URL

```
https://api.instagram-clone.com
```

For local development:

```
http://localhost:3000
```

## Authentication

Most endpoints require authentication. Authentication is handled using JSON Web Tokens (JWT).

To authenticate, include the JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

## API Gateway Endpoints

### Authentication

#### Register a new user

```
POST /auth/register
```

Request body:

```json
{
  "email": "user@example.com",
  "username": "username",
  "password": "password",
  "fullName": "Full Name"
}
```

Response:

```json
{
  "id": "user-id",
  "email": "user@example.com",
  "username": "username",
  "fullName": "Full Name",
  "createdAt": "2023-01-01T00:00:00Z"
}
```

#### Login

```
POST /auth/login
```

Request body:

```json
{
  "username": "username",
  "password": "password"
}
```

Response:

```json
{
  "accessToken": "jwt-token",
  "refreshToken": "refresh-token",
  "user": {
    "id": "user-id",
    "username": "username",
    "email": "user@example.com",
    "fullName": "Full Name"
  }
}
```

#### Refresh Token

```
POST /auth/refresh
```

Request body:

```json
{
  "refreshToken": "refresh-token"
}
```

Response:

```json
{
  "accessToken": "new-jwt-token",
  "refreshToken": "new-refresh-token"
}
```

### User Service

#### Get User Profile

```
GET /users/:username
```

Response:

```json
{
  "id": "user-id",
  "username": "username",
  "fullName": "Full Name",
  "bio": "User bio",
  "website": "https://example.com",
  "profilePicture": "profile-picture-url",
  "postsCount": 42,
  "followersCount": 1000,
  "followingCount": 500,
  "isPrivate": false,
  "isVerified": true
}
```

#### Update User Profile

```
PUT /users/profile
```

Request body:

```json
{
  "fullName": "Updated Name",
  "bio": "Updated bio",
  "website": "https://updated-example.com",
  "email": "updated@example.com",
  "phoneNumber": "+1234567890"
}
```

Response:

```json
{
  "id": "user-id",
  "username": "username",
  "fullName": "Updated Name",
  "bio": "Updated bio",
  "website": "https://updated-example.com",
  "email": "updated@example.com",
  "phoneNumber": "+1234567890",
  "updatedAt": "2023-01-02T00:00:00Z"
}
```

### Post Service

#### Create a Post

```
POST /posts
```

Request body (multipart/form-data):

```
caption: "Post caption"
media: [file1, file2, ...]
location: "Location name"
```

Response:

```json
{
  "id": "post-id",
  "caption": "Post caption",
  "location": "Location name",
  "media": [
    {
      "id": "media-id-1",
      "url": "media-url-1",
      "type": "image"
    },
    {
      "id": "media-id-2",
      "url": "media-url-2",
      "type": "video"
    }
  ],
  "user": {
    "id": "user-id",
    "username": "username",
    "profilePicture": "profile-picture-url"
  },
  "likesCount": 0,
  "commentsCount": 0,
  "createdAt": "2023-01-03T00:00:00Z"
}
```

#### Get Post by ID

```
GET /posts/:id
```

Response:

```json
{
  "id": "post-id",
  "caption": "Post caption",
  "location": "Location name",
  "media": [
    {
      "id": "media-id-1",
      "url": "media-url-1",
      "type": "image"
    }
  ],
  "user": {
    "id": "user-id",
    "username": "username",
    "profilePicture": "profile-picture-url"
  },
  "likesCount": 42,
  "commentsCount": 10,
  "createdAt": "2023-01-03T00:00:00Z",
  "isLiked": true
}
```

#### Get User Feed

```
GET /posts/feed
```

Query parameters:

```
page: 1 (default)
limit: 10 (default, max 50)
```

Response:

```json
{
  "posts": [
    {
      "id": "post-id-1",
      "caption": "Post caption 1",
      "media": [{"id": "media-id-1", "url": "media-url-1", "type": "image"}],
      "user": {
        "id": "user-id-1",
        "username": "username1",
        "profilePicture": "profile-picture-url-1"
      },
      "likesCount": 42,
      "commentsCount": 10,
      "createdAt": "2023-01-03T00:00:00Z",
      "isLiked": true
    },
    {
      "id": "post-id-2",
      "caption": "Post caption 2",
      "media": [{"id": "media-id-2", "url": "media-url-2", "type": "image"}],
      "user": {
        "id": "user-id-2",
        "username": "username2",
        "profilePicture": "profile-picture-url-2"
      },
      "likesCount": 30,
      "commentsCount": 5,
      "createdAt": "2023-01-02T00:00:00Z",
      "isLiked": false
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "totalPages": 5,
    "totalItems": 42
  }
}
```

### Social Service

#### Follow a User

```
POST /social/follow/:username
```

Response:

```json
{
  "success": true,
  "message": "Successfully followed user",
  "data": {
    "followerId": "your-user-id",
    "followingId": "target-user-id",
    "createdAt": "2023-01-04T00:00:00Z"
  }
}
```

#### Unfollow a User

```
DELETE /social/follow/:username
```

Response:

```json
{
  "success": true,
  "message": "Successfully unfollowed user"
}
```

#### Get Followers

```
GET /social/followers/:username
```

Query parameters:

```
page: 1 (default)
limit: 20 (default, max 100)
```

Response:

```json
{
  "followers": [
    {
      "id": "user-id-1",
      "username": "follower1",
      "fullName": "Follower One",
      "profilePicture": "profile-picture-url-1",
      "isFollowing": true
    },
    {
      "id": "user-id-2",
      "username": "follower2",
      "fullName": "Follower Two",
      "profilePicture": "profile-picture-url-2",
      "isFollowing": false
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "totalPages": 3,
    "totalItems": 50
  }
}
```

### Message Service

#### Get Conversations

```
GET /messages/conversations
```

Query parameters:

```
page: 1 (default)
limit: 20 (default, max 50)
```

Response:

```json
{
  "conversations": [
    {
      "id": "conversation-id-1",
      "participants": [
        {
          "id": "user-id-1",
          "username": "username1",
          "profilePicture": "profile-picture-url-1"
        },
        {
          "id": "user-id-2",
          "username": "username2",
          "profilePicture": "profile-picture-url-2"
        }
      ],
      "lastMessage": {
        "id": "message-id",
        "text": "Hello there!",
        "senderId": "user-id-1",
        "createdAt": "2023-01-05T00:00:00Z",
        "isRead": true
      },
      "unreadCount": 0,
      "updatedAt": "2023-01-05T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "totalPages": 2,
    "totalItems": 25
  }
}
```

#### Get Messages in a Conversation

```
GET /messages/conversations/:conversationId
```

Query parameters:

```
page: 1 (default)
limit: 50 (default, max 100)
```

Response:

```json
{
  "messages": [
    {
      "id": "message-id-1",
      "text": "Hello there!",
      "sender": {
        "id": "user-id-1",
        "username": "username1",
        "profilePicture": "profile-picture-url-1"
      },
      "createdAt": "2023-01-05T00:01:00Z",
      "isRead": true
    },
    {
      "id": "message-id-2",
      "text": "Hi! How are you?",
      "sender": {
        "id": "user-id-2",
        "username": "username2",
        "profilePicture": "profile-picture-url-2"
      },
      "createdAt": "2023-01-05T00:02:00Z",
      "isRead": true
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 50,
    "totalPages": 1,
    "totalItems": 2
  }
}
```

#### Send a Message

```
POST /messages
```

Request body:

```json
{
  "recipientId": "user-id-2",
  "text": "Hello, how are you?",
  "mediaId": "optional-media-id"
}
```

Response:

```json
{
  "id": "message-id",
  "text": "Hello, how are you?",
  "sender": {
    "id": "your-user-id",
    "username": "your-username",
    "profilePicture": "your-profile-picture-url"
  },
  "recipient": {
    "id": "user-id-2",
    "username": "recipient-username",
    "profilePicture": "recipient-profile-picture-url"
  },
  "media": null,
  "conversationId": "conversation-id",
  "createdAt": "2023-01-05T00:10:00Z",
  "isRead": false
}
```

### Story Service

#### Create a Story

```
POST /stories
```

Request body (multipart/form-data):

```
media: file
text: "Optional text overlay"
location: "Optional location"
```

Response:

```json
{
  "id": "story-id",
  "media": {
    "id": "media-id",
    "url": "media-url",
    "type": "image"
  },
  "text": "Optional text overlay",
  "location": "Optional location",
  "user": {
    "id": "your-user-id",
    "username": "your-username",
    "profilePicture": "your-profile-picture-url"
  },
  "viewsCount": 0,
  "expiresAt": "2023-01-06T00:00:00Z",
  "createdAt": "2023-01-05T00:00:00Z"
}
```

#### Get Stories

```
GET /stories
```

Response:

```json
{
  "stories": [
    {
      "user": {
        "id": "user-id-1",
        "username": "username1",
        "profilePicture": "profile-picture-url-1"
      },
      "items": [
        {
          "id": "story-id-1",
          "media": {
            "id": "media-id-1",
            "url": "media-url-1",
            "type": "image"
          },
          "text": "Story text 1",
          "location": "Location 1",
          "viewsCount": 42,
          "createdAt": "2023-01-05T00:00:00Z",
          "expiresAt": "2023-01-06T00:00:00Z",
          "isViewed": true
        },
        {
          "id": "story-id-2",
          "media": {
            "id": "media-id-2",
            "url": "media-url-2",
            "type": "video"
          },
          "text": null,
          "location": null,
          "viewsCount": 30,
          "createdAt": "2023-01-05T01:00:00Z",
          "expiresAt": "2023-01-06T01:00:00Z",
          "isViewed": false
        }
      ]
    },
    {
      "user": {
        "id": "user-id-2",
        "username": "username2",
        "profilePicture": "profile-picture-url-2"
      },
      "items": [
        {
          "id": "story-id-3",
          "media": {
            "id": "media-id-3",
            "url": "media-url-3",
            "type": "image"
          },
          "text": "Story text 3",
          "location": "Location 3",
          "viewsCount": 20,
          "createdAt": "2023-01-05T02:00:00Z",
          "expiresAt": "2023-01-06T02:00:00Z",
          "isViewed": false
        }
      ]
    }
  ]
}
```

### Search Service

#### Search

```
GET /search
```

Query parameters:

```
q: "search query"
type: "all" (default) | "users" | "posts" | "tags" | "locations"
page: 1 (default)
limit: 20 (default, max 50)
```

Response:

```json
{
  "users": [
    {
      "id": "user-id-1",
      "username": "username1",
      "fullName": "Full Name 1",
      "profilePicture": "profile-picture-url-1",
      "isVerified": true,
      "isFollowing": false
    }
  ],
  "posts": [
    {
      "id": "post-id-1",
      "caption": "Post caption 1",
      "media": [{"id": "media-id-1", "url": "media-url-1", "type": "image"}],
      "user": {
        "id": "user-id-1",
        "username": "username1",
        "profilePicture": "profile-picture-url-1"
      },
      "likesCount": 42,
      "commentsCount": 10,
      "createdAt": "2023-01-03T00:00:00Z"
    }
  ],
  "tags": [
    {
      "name": "tag1",
      "postsCount": 1000
    }
  ],
  "locations": [
    {
      "id": "location-id-1",
      "name": "Location 1",
      "postsCount": 500
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "totalPages": 1,
    "totalItems": {
      "users": 1,
      "posts": 1,
      "tags": 1,
      "locations": 1
    }
  }
}
```

## Error Responses

All API endpoints return standard error responses in the following format:

```json
{
  "statusCode": 400,
  "message": "Error message",
  "error": "Error type",
  "timestamp": "2023-01-01T00:00:00Z",
  "path": "/endpoint/path"
}
```

Common HTTP status codes:

- 200: OK
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 422: Unprocessable Entity
- 429: Too Many Requests
- 500: Internal Server Error

## Rate Limiting

API requests are subject to rate limiting. The current limits are:

- 100 requests per minute for authenticated users
- 20 requests per minute for unauthenticated users

Rate limit information is included in the response headers:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1672531200
```

## Pagination

Most endpoints that return lists of items support pagination using the following query parameters:

- `page`: Page number (1-based indexing)
- `limit`: Number of items per page

Pagination information is included in the response body:

```json
{
  "pagination": {
    "page": 1,
    "limit": 20,
    "totalPages": 5,
    "totalItems": 100
  }
}
```

## Versioning

The API version is included in the URL path:

```
https://api.instagram-clone.com/v1/endpoint
```

The current version is `v1`.