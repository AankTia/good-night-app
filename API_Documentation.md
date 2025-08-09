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
    "id": 48220,
    "sleep_time": "2025-08-09T16:31:29Z",
    "wake_up_time": null,
    "duration_hours": null,
    "duration_seconds": null,
    "created_at": "2025-08-09T16:31:29Z",
    "user": {
      "id": 1,
      "name": "Linn Trantow",
      "created_at": "2025-08-09T16:17:54Z"
    }
  },
  "all_records": [
    {
      "id": 1,
      "sleep_time": "2025-05-20T13:57:51Z",
      "wake_up_time": "2025-05-21T00:57:51Z",
      "duration_hours": 11.0,
      "duration_seconds": 39600,
      "created_at": "2025-08-09T16:17:59Z",
      "user": {
        "id": 1,
        "name": "Linn Trantow",
        "created_at": "2025-08-09T16:17:54Z"
      }
    }
  ],
  "total_count": 20,
  "pagination_notes": "Showing latest 20 records. Use /sleep_records for full pagination."
}
```

**Clock Out Response (200) :**

```json
{
  "message": "Clocked out successfully",
  "current_record": {
    "id": 48220,
    "sleep_time": "2025-08-09T16:31:29Z",
    "wake_up_time": "2025-08-09T16:33:09Z",
    "duration_hours": 0.03,
    "duration_seconds": 99,
    "created_at": "2025-08-09T16:31:29Z",
    "user": {
      "id": 1,
      "name": "Linn Trantow",
      "created_at": "2025-08-09T16:17:54Z"
    }
  },
  "all_records": [
    {
      "id": 1,
      "sleep_time": "2025-05-20T13:57:51Z",
      "wake_up_time": "2025-05-21T00:57:51Z",
      "duration_hours": 11.0,
      "duration_seconds": 39600,
      "created_at": "2025-08-09T16:17:59Z",
      "user": {
        "id": 1,
        "name": "Linn Trantow",
        "created_at": "2025-08-09T16:17:54Z"
      }
    }
  ],
  "total_count": 20,
  "pagination_notes": "Showing latest 20 records. Use /sleep_records for full pagination."
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
    "sleep_time": "2025-05-20T13:57:51Z",
    "wake_up_time": "2025-05-21T00:57:51Z",
    "duration_hours": 11.0,
    "duration_seconds": 39600,
    "created_at": "2025-08-09T16:17:59Z",
    "user": {
      "id": 1,
      "name": "Linn Trantow",
      "created_at": "2025-08-09T16:17:54Z"
    }
  }
}
```

### `GET /users/:user_id/sleep_records`

Get list of user sleep records

```bash
curl --location 'localhost:3000/api/v1/users/1/sleep_records?page=1&per_page=2'
```

**Response (200)**

```json
{
  "sleep_records": [
    {
      "id": 1,
      "sleep_time": "2025-05-20T13:57:51Z",
      "wake_up_time": "2025-05-21T00:57:51Z",
      "duration_hours": 11.0,
      "duration_seconds": 39600,
      "created_at": "2025-08-09T16:17:59Z",
      "user": {
        "id": 1,
        "name": "Linn Trantow",
        "created_at": "2025-08-09T16:17:54Z"
      }
    },
    {
      "id": 2,
      "sleep_time": "2025-08-01T18:34:09Z",
      "wake_up_time": "2025-08-02T05:34:09Z",
      "duration_hours": 11.0,
      "duration_seconds": 39600,
      "created_at": "2025-08-09T16:17:59Z",
      "user": {
        "id": 1,
        "name": "Linn Trantow",
        "created_at": "2025-08-09T16:17:54Z"
      }
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 10,
    "total_count": 20,
    "next_cursor": null,
    "per_page": 2
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
      "id": 88,
      "sleep_time": "2025-07-21T08:13:12Z",
      "wake_up_time": "2025-07-21T12:13:12Z",
      "duration_hours": 4.0,
      "duration_seconds": 14400,
      "created_at": "2025-08-09T16:17:59Z",
      "user": {
        "id": 5,
        "name": "Franklin Senger",
        "created_at": "2025-08-09T16:17:54Z"
      }
    },
    {
      "id": 387,
      "sleep_time": "2025-07-19T01:37:54Z",
      "wake_up_time": "2025-07-19T06:37:54Z",
      "duration_hours": 5.0,
      "duration_seconds": 18000,
      "created_at": "2025-08-09T16:17:59Z",
      "user": {
        "id": 14,
        "name": "Nikia Barton",
        "created_at": "2025-08-09T16:17:54Z"
      }
    },
    {
      "id": 848,
      "sleep_time": "2025-05-22T06:54:03Z",
      "wake_up_time": "2025-05-22T12:54:03Z",
      "duration_hours": 6.0,
      "duration_seconds": 21600,
      "created_at": "2025-08-09T16:18:01Z",
      "user": {
        "id": 28,
        "name": "Junior Konopelski",
        "created_at": "2025-08-09T16:17:54Z"
      }
    }
  ],
  "summary": {
    "total_records": 3,
    "following_count": 3,
    "date_range": {
      "from": "2025-08-02",
      "to": "2025-08-09"
    },
    "cached": true,
    "cache_expires_id": "1 hour"
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
curl --location 'localhost:3000/api/v1/users/1/followings?page=1&per_page=2'
```

**Response (200)**

```json
{
  "followings": [
    {
      "id": 5,
      "name": "Franklin Senger",
      "created_at": "2025-08-09T16:17:54Z"
    },
    {
      "id": 6,
      "name": "Mrs. Starla Stamm",
      "created_at": "2025-08-09T16:17:54Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 8,
    "total_count": 15
  }
}
```
