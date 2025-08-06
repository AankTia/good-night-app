# API Documetation

## Base URL

```
Development: http://localhost:3000/api/v1
```

## Error Responses

All endpoints return errors in the following format:

```json
{
  "error": "Error message",
  "details": ["Specific error details"],
  "status": 400
}
```

Common HTTP status codes:

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Unprocessable Entity
- `500` - Internal Server Error

## Sleep Record

### `POST /users/:user_id/sleep_records`

Clock in & Clock Out

```bash
curl --location --request POST 'localhost:3000/api/v1/users/1/sleep_records'
```

**Clock In Response (201) :**

```json
{
  "message": "Clocked in successfully",
  "current_record": {
    "id": 1,
    "sleep_time": "2025-08-06T15:37:03Z",
    "wake_up_time": null,
    "duration_hours": null,
    "duration_seconds": null,
    "created_at": "2025-08-06T15:37:03Z",
    "user": {
      "id": 1,
      "name": "Evonne Howe",
      "created_at": "2025-08-06T15:36:31Z"
    }
  },
  "all_records": [
    {
      "id": 1,
      "sleep_time": "2025-08-06T15:37:03Z",
      "wake_up_time": null,
      "duration_hours": null,
      "duration_seconds": null,
      "created_at": "2025-08-06T15:37:03Z",
      "user": {
        "id": 1,
        "name": "Evonne Howe",
        "created_at": "2025-08-06T15:36:31Z"
      }
    }
  ]
}
```

**Clock Out Response (200) :**

```json
{
  "message": "Clocked out successfully",
  "current_record": {
    "id": 1,
    "sleep_time": "2025-08-06T15:37:03Z",
    "wake_up_time": "2025-08-06T15:37:26Z",
    "duration_hours": 0.01,
    "duration_seconds": 22,
    "created_at": "2025-08-06T15:37:03Z",
    "user": {
      "id": 1,
      "name": "Evonne Howe",
      "created_at": "2025-08-06T15:36:31Z"
    }
  },
  "all_records": [
    {
      "id": 1,
      "sleep_time": "2025-08-06T15:37:03Z",
      "wake_up_time": "2025-08-06T15:37:26Z",
      "duration_hours": 0.01,
      "duration_seconds": 22,
      "created_at": "2025-08-06T15:37:03Z",
      "user": {
        "id": 1,
        "name": "Evonne Howe",
        "created_at": "2025-08-06T15:36:31Z"
      }
    }
  ]
}
```

### `GET /users/:user_id/sleep_records/:id`

Get Sleep Record detail

```bash
curl --location 'localhost:3000/api/v1/users/1/sleep_records/1'
```

**Response (200)**

```json
{
  "sleep_record": {
    "id": 1,
    "sleep_time": "2025-08-06T15:37:03Z",
    "wake_up_time": "2025-08-06T15:37:26Z",
    "duration_hours": 0.01,
    "duration_seconds": 22,
    "created_at": "2025-08-06T15:37:03Z",
    "user": {
      "id": 1,
      "name": "Evonne Howe",
      "created_at": "2025-08-06T15:36:31Z"
    }
  }
}
```

### `GET /users/:user_id/sleep_records`

Get list of sleep records

```bash
curl --location 'localhost:3000/api/v1/users/1/sleep_records'
```

**Response (200)**

```json
{
  "sleep_records": [
    {
      "id": 1,
      "sleep_time": "2025-08-06T15:37:03Z",
      "wake_up_time": "2025-08-06T15:37:26Z",
      "duration_hours": 0.01,
      "duration_seconds": 22,
      "created_at": "2025-08-06T15:37:03Z",
      "user": {
        "id": 1,
        "name": "Evonne Howe",
        "created_at": "2025-08-06T15:36:31Z"
      }
    },
    {
      "id": 2,
      "sleep_time": "2025-08-06T15:40:32Z",
      "wake_up_time": "2025-08-06T15:40:43Z",
      "duration_hours": 0.0,
      "duration_seconds": 11,
      "created_at": "2025-08-06T15:40:32Z",
      "user": {
        "id": 1,
        "name": "Evonne Howe",
        "created_at": "2025-08-06T15:36:31Z"
      }
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_count": 2
  }
}
```

### `GET /users/:user_id/sleep_records/friends_sleep_records`

Get Friends Sleep Records

```bash
curl --location 'localhost:3000/api/v1/users/1/sleep_records/friends_sleep_records'
```

**Response (200)**

```json
{
  "sleep_records": [
    {
      "id": 3,
      "sleep_time": "2025-08-06T15:46:39Z",
      "wake_up_time": "2025-08-06T15:46:45Z",
      "duration_hours": 0.0,
      "duration_seconds": 5,
      "created_at": "2025-08-06T15:46:39Z",
      "user": {
        "id": 2,
        "name": "Alverta Mills Jr.",
        "created_at": "2025-08-06T15:36:31Z"
      }
    },
    {
      "id": 4,
      "sleep_time": "2025-08-06T15:46:52Z",
      "wake_up_time": "2025-08-06T15:46:58Z",
      "duration_hours": 0.0,
      "duration_seconds": 6,
      "created_at": "2025-08-06T15:46:52Z",
      "user": {
        "id": 2,
        "name": "Alverta Mills Jr.",
        "created_at": "2025-08-06T15:36:31Z"
      }
    },
    {
      "id": 6,
      "sleep_time": "2025-08-06T15:47:20Z",
      "wake_up_time": "2025-08-06T15:47:27Z",
      "duration_hours": 0.0,
      "duration_seconds": 7,
      "created_at": "2025-08-06T15:47:20Z",
      "user": {
        "id": 4,
        "name": "Dr. Greg Wintheiser",
        "created_at": "2025-08-06T15:36:31Z"
      }
    },
    {
      "id": 5,
      "sleep_time": "2025-08-06T15:47:04Z",
      "wake_up_time": "2025-08-06T15:47:13Z",
      "duration_hours": 0.0,
      "duration_seconds": 8,
      "created_at": "2025-08-06T15:47:04Z",
      "user": {
        "id": 3,
        "name": "Jason Fritsch",
        "created_at": "2025-08-06T15:36:31Z"
      }
    }
  ],
  "summary": {
    "total_records": 4,
    "date_range": {
      "from": "2025-07-30",
      "to": "2025-08-06"
    }
  }
}
```

## User Following

### `POST /users/:user_id/followings`

Follow User

```bash
curl --location 'localhost:3000/api/v1/users/1/followings' \
--form 'target_user_id="2"'
```

**Response (201)**

```json
{
  "message": "Successfully followed Alverta Mills Jr.",
  "following": {
    "id": 2,
    "name": "Alverta Mills Jr.",
    "created_at": "2025-08-06T15:36:31Z"
  }
}
```

## `DELETE users/:user_id/followings/:target_user_id`

Unfollow User

```bash
curl --location --request DELETE 'localhost:3000/api/v1/users/1/followings/4'
```

**Response (200)**

```json
{
  "message": "Successfully unfollowed Dr. Greg Wintheiser"
}
```

## `GET users/:user_id/followings`

List of Following User

```bash
curl --location 'localhost:3000/api/v1/users/1/followings'
```

**Response (200)**

```json
{
  "followings": [
    {
      "id": 2,
      "name": "Alverta Mills Jr.",
      "created_at": "2025-08-06T15:36:31Z"
    },
    {
      "id": 3,
      "name": "Jason Fritsch",
      "created_at": "2025-08-06T15:36:31Z"
    },
    {
      "id": 4,
      "name": "Dr. Greg Wintheiser",
      "created_at": "2025-08-06T15:36:31Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_count": 3
  }
}
```
