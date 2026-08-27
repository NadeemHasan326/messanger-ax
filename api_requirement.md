# Messanger AX — API Specification

Base URL: `https://api.messangerax.app/v1`

**Headers (auth APIs):** `Authorization: Bearer {access_token}`  
**Headers (all):** `Accept: application/json` · `Content-Type: application/json`  
**Upload:** `multipart/form-data`  
**IDs:** UUID · **Dates:** ISO-8601 UTC

Envelope:

```json
{ "success": true, "data": {} }
```

```json
{ "success": false, "error": { "code": "VALIDATION_ERROR", "message": "...", "fields": {} } }
```

Paginated `data`: `{ "items": [], "next_cursor": null, "has_more": false }`

Responses below are the `data` object.

---

## Authentication

**Required APIs**

- `POST` `/auth/login`
- `POST` `/auth/register`
- `POST` `/auth/verify-email`
- `POST` `/auth/resend-email-otp`
- `POST` `/auth/forgot-password`
- `POST` `/auth/forgot-password/verify`
- `POST` `/auth/reset-password`
- `POST` `/auth/logout`
- `POST` `/auth/refresh`
- `POST` `/auth/2fa/verify`

---

`POST`: `/auth/login`

Request:

```json
{
  "identifier": "nadeem@virexon.com",
  "password": "secret1",
  "device": {
    "name": "iPhone 15",
    "platform": "ios",
    "push_token": "optional"
  }
}
```

Response:

```json
{
  "access_token": "jwt",
  "refresh_token": "opaque",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": {
    "id": "uuid",
    "name": "Nadeem Hasan",
    "username": "nadeemhasan",
    "email": "nadeem@virexon.com",
    "phone": "9876543210",
    "about": "Hey there! I am using Messanger AX.",
    "status": "Available",
    "avatar_url": "https://...",
    "email_verified": true,
    "created_at": "2026-03-01T00:00:00Z"
  }
}
```

If 2FA enabled:

```json
{ "two_step_required": true, "challenge_id": "uuid" }
```

---

`POST`: `/auth/register`

Request:

```json
{
  "name": "Nadeem Hasan",
  "email": "nadeem@virexon.com",
  "mobile": "9876543210",
  "password": "secret1",
  "password_confirmation": "secret1",
  "accepted_terms": true,
  "invite_code": null
}
```

Response:

```json
{
  "user_id": "uuid",
  "email": "nadeem@virexon.com",
  "email_verified": false,
  "otp_length": 4,
  "otp_expires_in": 300
}
```

---

`POST`: `/auth/verify-email`

Request:

```json
{ "email": "nadeem@virexon.com", "otp": "1234" }
```

Response:

```json
{ "email_verified": true }
```

---

`POST`: `/auth/resend-email-otp`

Request:

```json
{ "email": "nadeem@virexon.com" }
```

Response:

```json
{ "sent": true, "otp_expires_in": 300 }
```

---

`POST`: `/auth/forgot-password`

Request:

```json
{ "mobile": "9876543210" }
```

Response:

```json
{ "sent": true }
```

---

`POST`: `/auth/forgot-password/verify`

Request:

```json
{ "mobile": "9876543210", "otp": "1234" }
```

Response:

```json
{ "reset_token": "opaque", "expires_in": 600 }
```

---

`POST`: `/auth/reset-password`

Request:

```json
{
  "reset_token": "opaque",
  "password": "newpass",
  "password_confirmation": "newpass"
}
```

Response:

```json
{ "reset": true }
```

---

`POST`: `/auth/logout`

Request:

```json
{ "refresh_token": "opaque" }
```

Response:

```json
{ "logged_out": true }
```

---

`POST`: `/auth/refresh`

Request:

```json
{ "refresh_token": "opaque" }
```

Response:

```json
{
  "access_token": "jwt",
  "refresh_token": "opaque",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

---

`POST`: `/auth/2fa/verify`

Request:

```json
{ "challenge_id": "uuid", "pin": "123456" }
```

Response: same as login token response.

---

## Profile

**Required APIs**

- `GET` `/me`
- `PATCH` `/me`
- `POST` `/me/avatar`
- `DELETE` `/me`
- `GET` `/users/{id}`
- `POST` `/users/{id}/follow`
- `DELETE` `/users/{id}/follow`
- `GET` `/users/{id}/posts`
- `PATCH` `/me/presence`

---

`GET`: `/me`

Request: —

Response:

```json
{
  "id": "uuid",
  "name": "Nadeem Hasan",
  "username": "nadeemhasan",
  "email": "nadeem@virexon.com",
  "phone": "9876543210",
  "about": "Hey there! I am using Messanger AX.",
  "status": "Available",
  "avatar_url": "https://...",
  "email_verified": true,
  "created_at": "2026-03-01T00:00:00Z",
  "notifications_enabled": true,
  "disappearing_duration": "off",
  "reply_allowed": true,
  "read_receipts": true
}
```

---

`PATCH`: `/me`

Request:

```json
{
  "name": "Nadeem Hasan",
  "username": "nadeemhasan",
  "about": "Hey there! I am using Messanger AX.",
  "email": "nadeem@virexon.com",
  "phone": "9876543210"
}
```

Response: same as `GET /me`.

---

`POST`: `/me/avatar`

Request: `multipart/form-data` · field `file`

Response:

```json
{ "avatar_url": "https://..." }
```

---

`DELETE`: `/me`

Request: —

Response:

```json
{ "deleted": true }
```

---

`GET`: `/users/{id}`

Request: —

Response:

```json
{
  "id": "uuid",
  "name": "Olivia Williams",
  "username": "olivia.w",
  "bio": "string",
  "role": "Marketing Lead",
  "avatar_url": "https://...",
  "online": true,
  "last_seen_at": "2026-08-27T10:00:00Z",
  "posts_count": 24,
  "followers_count": 2400,
  "following_count": 186,
  "is_following": false,
  "about": "string",
  "media_count": 17,
  "media_preview": [
    { "message_id": "uuid", "thumb_url": "https://...", "kind": "image" }
  ],
  "groups_in_common": [
    { "id": "uuid", "name": "Design Team", "member_count": 24 }
  ]
}
```

---

`POST`: `/users/{id}/follow`

Request: —

Response:

```json
{ "is_following": true, "followers_count": 2401 }
```

---

`DELETE`: `/users/{id}/follow`

Request: —

Response:

```json
{ "is_following": false, "followers_count": 2400 }
```

---

`GET`: `/users/{id}/posts`

Request: —

Response:

```json
{
  "items": [
    { "id": "uuid", "thumb_url": "https://...", "created_at": "2026-08-27T10:00:00Z" }
  ]
}
```

---

`PATCH`: `/me/presence`

Request:

```json
{ "online": true }
```

Response:

```json
{ "online": true, "last_seen_at": "2026-08-27T10:00:00Z" }
```

---

## Privacy & Security

**Required APIs**

- `GET` `/me/privacy`
- `PATCH` `/me/privacy`
- `GET` `/me/blocked`
- `POST` `/users/{id}/block`
- `DELETE` `/users/{id}/block`
- `POST` `/reports`
- `GET` `/me/sessions`
- `POST` `/me/2fa`

---

`GET`: `/me/privacy`

Request: —

Response:

```json
{
  "last_seen": "contacts",
  "profile_photo": "everyone",
  "about": "contacts",
  "status": "contacts",
  "disappearing_duration": "off",
  "allow_replies": true,
  "read_receipts": true,
  "screenshot_blocked": false,
  "screenshot_alerts": true,
  "two_step_enabled": false,
  "screen_lock": false,
  "login_alerts": true
}
```

`visibility`: `everyone` | `contacts` | `nobody`  
`disappearing_duration`: `off` | `hours24` | `days3` | `days7` | `days30` | `days90`

---

`PATCH`: `/me/privacy`

Request: any subset of privacy fields above.

Response: full privacy object.

---

`GET`: `/me/blocked`

Request: —

Response:

```json
{
  "items": [
    {
      "user_id": "uuid",
      "name": "Jordan Hale",
      "avatar_url": "https://...",
      "blocked_at": "2026-08-12T00:00:00Z"
    }
  ]
}
```

---

`POST`: `/users/{id}/block`

Request: —

Response:

```json
{ "blocked": true }
```

---

`DELETE`: `/users/{id}/block`

Request: —

Response:

```json
{ "blocked": false }
```

---

`POST`: `/reports`

Request:

```json
{
  "target_type": "user",
  "target_id": "uuid",
  "conversation_id": "uuid",
  "include_recent_messages": true,
  "reason": null
}
```

`target_type`: `user` | `group` | `channel`

Response:

```json
{ "report_id": "uuid" }
```

---

`GET`: `/me/sessions`

Request: —

Response:

```json
{
  "items": [
    {
      "id": "uuid",
      "device_name": "iPhone 15",
      "platform": "ios",
      "ip": "x.x.x.x",
      "last_active_at": "2026-08-27T11:00:00Z",
      "current": true
    }
  ]
}
```

---

`POST`: `/me/2fa`

Request:

```json
{ "enabled": true, "pin": "123456" }
```

Response:

```json
{ "two_step_enabled": true }
```

---

## Contacts

**Required APIs**

- `GET` `/contacts`
- `POST` `/contacts`

---

`GET`: `/contacts`

Request (query): `q` · `filter=all|team|friends|family` · `recent=true`

Response:

```json
{
  "items": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "name": "Alex Rivera",
      "role": "Product Manager",
      "phone": "+919876543210",
      "avatar_url": "https://...",
      "online": true,
      "is_app_user": true,
      "recent": false
    }
  ]
}
```

---

`POST`: `/contacts`

Request:

```json
{
  "name": "Nina Williams",
  "role": "Product Designer",
  "phone_e164": "+14155552671",
  "country_iso": "US",
  "user_id": null
}
```

Response: contact object (same as list item).

---

## Chat

**Required APIs**

- `GET` `/conversations`
- `GET` `/me/unread`
- `POST` `/conversations/{id}/pin`
- `DELETE` `/conversations/{id}/pin`
- `POST` `/conversations/{id}/mute`
- `POST` `/conversations/{id}/lock`
- `POST` `/conversations/{id}/hide`
- `POST` `/conversations/direct`
- `POST` `/conversations/{id}/read`
- `POST` `/conversations/{id}/lists`
- `POST` `/conversations/{id}/export`
- `GET` `/conversations/{id}/media`
- `PATCH` `/conversations/{id}/disappearing`
- `GET` `/conversations/{id}/messages`
- `POST` `/conversations/{id}/messages`
- `DELETE` `/conversations/{id}/messages`
- `POST` `/messages/{id}/view-once`
- `POST` `/conversations/{id}/live-location`
- `PATCH` `/live-location/{share_id}`
- `POST` `/messages/delete-for-me`
- `POST` `/messages/delete-for-everyone`
- `POST` `/messages/{id}/ack`
- `POST` `/conversations/{id}/screenshot`
- `POST` `/messages/{id}/reactions`
- `DELETE` `/messages/{id}/reactions`

---

`GET`: `/conversations`

Request (query): `filter=all|unread|pinned|groups|channels` · `hidden=true`

Response:

```json
{
  "unread_conversation_count": 3,
  "items": [
    {
      "id": "uuid",
      "type": "dm",
      "name": "Olivia Williams",
      "avatar_url": "https://...",
      "last_message_preview": "Can we sync?",
      "last_message_at": "2026-08-27T09:41:00Z",
      "unread_count": 2,
      "pinned": false,
      "muted": false,
      "locked": false,
      "hidden": false,
      "online": true,
      "last_outgoing_status": "read",
      "peer": { "id": "uuid", "name": "Olivia Williams", "avatar_url": "https://..." },
      "group": null,
      "channel": null
    }
  ]
}
```

`type`: `dm` | `group` | `channel`  
`last_outgoing_status`: `sent` | `delivered` | `read` | `null`

Group item includes:

```json
{ "group": { "id": "uuid", "member_count": 5, "only_admins_can_send": false } }
```

Channel item includes:

```json
{
  "channel": {
    "id": "uuid",
    "handle": "@axupdates",
    "followers": 128,
    "is_admin": false,
    "is_joined": true,
    "description": "Official news"
  }
}
```

---

`GET`: `/me/unread`

Request: —

Response:

```json
{ "conversations": 4, "notifications": 3, "missed_calls": 0 }
```

---

`POST`: `/conversations/{id}/pin`

Request: —

Response:

```json
{ "pinned": true }
```

---

`DELETE`: `/conversations/{id}/pin`

Request: —

Response:

```json
{ "pinned": false }
```

---

`POST`: `/conversations/{id}/mute`

Request:

```json
{ "muted": true }
```

Response:

```json
{ "muted": true }
```

---

`POST`: `/conversations/{id}/lock`

Request:

```json
{ "locked": true }
```

Response:

```json
{ "locked": true }
```

---

`POST`: `/conversations/{id}/hide`

Request:

```json
{ "hidden": true }
```

Response:

```json
{ "hidden": true }
```

---

`POST`: `/conversations/direct`

Request:

```json
{ "user_id": "uuid" }
```

Response: conversation object.

---

`POST`: `/conversations/{id}/read`

Request:

```json
{ "last_read_message_id": "uuid" }
```

Response:

```json
{ "unread_count": 0 }
```

---

`POST`: `/conversations/{id}/lists`

Request:

```json
{ "list": "favourites" }
```

`list`: `favourites` | `family` | `work`

Response:

```json
{ "lists": ["favourites"] }
```

---

`POST`: `/conversations/{id}/export`

Request:

```json
{ "include_media": false }
```

Response:

```json
{ "download_url": "https://...", "expires_at": "2026-08-27T12:00:00Z" }
```

---

`GET`: `/conversations/{id}/media`

Request (query): `type=media|links|docs`

Response:

```json
{
  "items": [
    {
      "message_id": "uuid",
      "kind": "image",
      "url": "https://...",
      "name": "photo.jpg",
      "created_at": "2026-08-27T09:00:00Z"
    }
  ]
}
```

---

`PATCH`: `/conversations/{id}/disappearing`

Request:

```json
{ "duration": "days7" }
```

Response:

```json
{ "duration": "days7" }
```

---

`GET`: `/conversations/{id}/messages`

Request (query): `cursor` · `limit` · `q`

Response:

```json
{
  "items": [
    {
      "id": "uuid",
      "conversation_id": "uuid",
      "sender_id": "uuid",
      "is_mine": true,
      "type": "text",
      "text": "Sure, I’m free after 4.",
      "created_at": "2026-08-27T09:19:00Z",
      "expires_at": null,
      "status": "sent",
      "is_system": false,
      "is_deleted": false,
      "file": null,
      "location": null,
      "reply_to": { "id": "uuid", "preview": "Can we sync?", "is_mine": false },
      "voice_duration_ms": null,
      "view_once": false,
      "view_once_opened": false,
      "mentioned_user_ids": []
    }
  ]
}
```

`type`: `text` | `image` | `file` | `voice` | `location` | `view_once` | `system`

---

`POST`: `/conversations/{id}/messages`

Request (text):

```json
{
  "type": "text",
  "text": "Hello",
  "reply_to_id": null,
  "mentioned_user_ids": []
}
```

Request (image / file):

```json
{ "type": "image", "media_id": "uuid", "file_name": "photo.jpg", "reply_to_id": null }
```

Request (view once):

```json
{ "type": "view_once", "media_id": "uuid" }
```

Request (voice):

```json
{ "type": "voice", "media_id": "uuid", "duration_ms": 4000 }
```

Request (location):

```json
{
  "type": "location",
  "location_type": "current",
  "lat": 19.076,
  "lng": 72.877
}
```

Response: message object. `"status": "sent"` (channel posts: `"status": null`).

---

`DELETE`: `/conversations/{id}/messages`

Request: —

Response:

```json
{ "cleared": true }
```

---

`POST`: `/messages/{id}/view-once`

Request: —

Response:

```json
{ "media_url": "https://...", "expires_in": 30 }
```

---

`POST`: `/conversations/{id}/live-location`

Request:

```json
{ "duration": "15m", "lat": 19.076, "lng": 72.877 }
```

`duration`: `15m` | `1h` | `8h`

Response: message object with:

```json
{
  "location": {
    "type": "live",
    "lat": 19.076,
    "lng": 72.877,
    "live_duration": "15m",
    "share_id": "uuid"
  }
}
```

---

`PATCH`: `/live-location/{share_id}`

Request:

```json
{ "lat": 19.076, "lng": 72.877 }
```

Response:

```json
{ "share_id": "uuid", "lat": 19.076, "lng": 72.877 }
```

---

`POST`: `/messages/delete-for-me`

Request:

```json
{ "message_ids": ["uuid"] }
```

Response:

```json
{ "deleted": ["uuid"] }
```

---

`POST`: `/messages/delete-for-everyone`

Request:

```json
{ "message_ids": ["uuid"] }
```

Response: tombstoned message objects (`is_deleted: true`, `text: "This message was deleted"`).

---

`POST`: `/messages/{id}/ack`

Request:

```json
{ "status": "delivered" }
```

`status`: `delivered` | `read`

Response:

```json
{ "status": "delivered" }
```

---

`POST`: `/conversations/{id}/screenshot`

Request:

```json
{ "context": "chat" }
```

`context`: `chat` | `story`

Response:

```json
{ "ok": true }
```

---

`POST`: `/messages/{id}/reactions`

Request:

```json
{ "emoji": "👍" }
```

Response:

```json
{ "emoji": "👍", "count": 1 }
```

---

`DELETE`: `/messages/{id}/reactions`

Request: —

Response:

```json
{ "emoji": null, "count": 0 }
```

---

## Groups

**Required APIs**

- `POST` `/groups`
- `GET` `/groups/{id}`
- `POST` `/groups/{id}/members`
- `POST` `/groups/{id}/admins/{user_id}`
- `DELETE` `/groups/{id}/admins/{user_id}`
- `PATCH` `/groups/{id}/permissions`

---

`POST`: `/groups`

Request:

```json
{
  "name": "Design Team",
  "member_ids": ["uuid", "uuid"]
}
```

Optional multipart field `avatar`.

Response: conversation object (`type: group`).

---

`GET`: `/groups/{id}`

Request: —

Response:

```json
{
  "id": "uuid",
  "name": "Design Team",
  "avatar_url": "https://...",
  "only_admins_can_send": false,
  "members": [
    {
      "user_id": "uuid",
      "name": "Olivia Williams",
      "role": "Marketing Lead",
      "is_admin": true,
      "avatar_url": "https://..."
    }
  ]
}
```

---

`POST`: `/groups/{id}/members`

Request:

```json
{ "user_ids": ["uuid"] }
```

Response: updated group object.

---

`POST`: `/groups/{id}/admins/{user_id}`

Request: —

Response:

```json
{ "is_admin": true }
```

---

`DELETE`: `/groups/{id}/admins/{user_id}`

Request: —

Response:

```json
{ "is_admin": false }
```

---

`PATCH`: `/groups/{id}/permissions`

Request:

```json
{ "only_admins_can_send": true }
```

Response:

```json
{ "only_admins_can_send": true }
```

---

## Channels

**Required APIs**

- `POST` `/channels`
- `GET` `/channels/name-available`
- `GET` `/channels`
- `GET` `/channels/{id}`
- `POST` `/channels/{id}/follow`
- `DELETE` `/channels/{id}/follow`
- `PATCH` `/channels/{id}`
- `DELETE` `/channels/{id}`
- `GET` `/channels/{id}/invite`
- `POST` `/channels/join`

---

`POST`: `/channels`

Request:

```json
{
  "name": "AX Updates",
  "description": "Official news from Messanger AX"
}
```

Optional multipart field `avatar`.

Response:

```json
{
  "id": "uuid",
  "conversation_id": "uuid",
  "name": "AX Updates",
  "slug": "axupdates",
  "handle": "@axupdates",
  "description": "Official news from Messanger AX",
  "avatar_url": "https://...",
  "followers": 1,
  "last_post": "You created this channel",
  "last_post_at": "2026-08-27T10:00:00Z",
  "is_admin": true,
  "is_joined": true,
  "unread": 0,
  "created_at": "2026-08-27T10:00:00Z",
  "invite_url": "https://ax.app/c/axupdates",
  "post_count": 1
}
```

---

`GET`: `/channels/name-available`

Request (query): `name=AX Updates`

Response:

```json
{ "available": true, "slug": "axupdates" }
```

---

`GET`: `/channels`

Request (query): `q` · `joined=true`

Response:

```json
{ "items": [{ "...channel object..." }] }
```

---

`GET`: `/channels/{id}`

Request: —

Response: channel object +

```json
{
  "role": "admin",
  "recent_posts": [{ "...message object..." }]
}
```

`role`: `admin` | `following` | `not_following`

---

`POST`: `/channels/{id}/follow`

Request: —

Response: channel object (`is_joined: true`).

---

`DELETE`: `/channels/{id}/follow`

Request: —

Response: channel object (`is_joined: false`).

---

`PATCH`: `/channels/{id}`

Request:

```json
{ "description": "New description" }
```

Response: channel object.

---

`DELETE`: `/channels/{id}`

Request: —

Response:

```json
{ "deleted": true }
```

---

`GET`: `/channels/{id}/invite`

Request: —

Response:

```json
{ "url": "https://ax.app/c/axupdates", "handle": "@axupdates" }
```

---

`POST`: `/channels/join`

Request:

```json
{ "slug": "axupdates" }
```

Response: channel object (`is_joined: true`).

---

## Story

**Required APIs**

- `GET` `/stories/feed`
- `GET` `/users/{id}/stories`
- `POST` `/stories`
- `POST` `/stories/{id}/view`
- `GET` `/stories/{id}/viewers`
- `POST` `/stories/{id}/replies`
- `POST` `/stories/{id}/like`
- `DELETE` `/stories/{id}/like`
- `DELETE` `/stories/{id}`

---

`GET`: `/stories/feed`

Request: —

Response:

```json
{
  "mine": {
    "has_update": true,
    "visibility_label": "Visible to 12",
    "viewer_count": 12
  },
  "items": [
    {
      "user_id": "uuid",
      "name": "David",
      "avatar_url": "https://...",
      "has_unseen": true,
      "online": true
    }
  ]
}
```

---

`GET`: `/users/{id}/stories`

Request: —

Response:

```json
{
  "user": { "id": "uuid", "name": "David", "online": true, "avatar_url": "https://..." },
  "stories": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "type": "text",
      "privacy": "everyone",
      "caption": "Shipping today",
      "text": "Hello",
      "background_color": "#1A73E8",
      "media_url": null,
      "created_at": "2026-08-27T10:00:00Z",
      "expires_at": "2026-08-28T10:00:00Z",
      "viewer_count": 12,
      "liked": false
    }
  ]
}
```

`type`: `camera` | `gallery` | `text`  
`privacy`: `everyone` | `contacts` | `selected`

---

`POST`: `/stories`

Request:

```json
{
  "type": "text",
  "privacy": "selected",
  "selected_user_ids": ["uuid"],
  "caption": null,
  "text": "Hello",
  "background_color": "#1A73E8",
  "media_id": null
}
```

Response:

```json
{
  "id": "uuid",
  "visibility_label": "Visible to 3"
}
```

---

`POST`: `/stories/{id}/view`

Request: —

Response:

```json
{ "viewed": true }
```

---

`GET`: `/stories/{id}/viewers`

Request: —

Response:

```json
{
  "count": 12,
  "items": [
    { "user_id": "uuid", "name": "Olivia Williams", "viewed_at": "2026-08-27T10:05:00Z" }
  ]
}
```

---

`POST`: `/stories/{id}/replies`

Request:

```json
{ "text": "Nice!" }
```

Response:

```json
{ "conversation_id": "uuid", "message_id": "uuid" }
```

---

`POST`: `/stories/{id}/like`

Request: —

Response:

```json
{ "liked": true }
```

---

`DELETE`: `/stories/{id}/like`

Request: —

Response:

```json
{ "liked": false }
```

---

`DELETE`: `/stories/{id}`

Request: —

Response:

```json
{ "deleted": true }
```

---

## Calls

**Required APIs**

- `GET` `/calls`
- `POST` `/calls`
- `POST` `/calls/{id}/answer`
- `POST` `/calls/{id}/reject`
- `POST` `/calls/{id}/end`
- `GET` `/calls/voicemail`

---

`GET`: `/calls`

Request (query): `tab=all|missed|voicemail` · `range=all|today|yesterday|week` · `q`

Response:

```json
{
  "items": [
    {
      "id": "uuid",
      "peer": { "id": "uuid", "name": "Olivia Williams", "avatar_url": "https://...", "online": true },
      "media": "audio",
      "direction": "outgoing",
      "status": "ended",
      "started_at": "2026-08-27T09:20:00Z",
      "ended_at": "2026-08-27T09:24:00Z",
      "duration_s": 240,
      "has_voicemail": false
    }
  ]
}
```

`direction`: `incoming` | `outgoing` | `missed`  
`status`: `ringing` | `connecting` | `active` | `ended` | `rejected` | `missed` | `busy`

---

`POST`: `/calls`

Request:

```json
{ "callee_id": "uuid", "media": "audio" }
```

Response:

```json
{
  "call": { "...call object...", "status": "ringing" },
  "ice_servers": [{ "urls": ["stun:stun.l.google.com:19302"] }]
}
```

---

`POST`: `/calls/{id}/answer`

Request:

```json
{ "sdp": "..." }
```

Response: call object (`status: active`).

---

`POST`: `/calls/{id}/reject`

Request: —

Response:

```json
{ "status": "rejected" }
```

---

`POST`: `/calls/{id}/end`

Request:

```json
{ "reason": "hangup" }
```

`reason`: `hangup` | `timeout` | `reject`

Response:

```json
{ "duration_s": 42, "direction": "outgoing", "status": "ended" }
```

---

`GET`: `/calls/voicemail`

Request: —

Response:

```json
{
  "items": [
    {
      "id": "uuid",
      "from": { "id": "uuid", "name": "Olivia Williams" },
      "audio_url": "https://...",
      "duration_ms": 12000,
      "created_at": "2026-08-27T09:00:00Z",
      "listened": false
    }
  ]
}
```

---

## Media

**Required APIs**

- `POST` `/media`

---

`POST`: `/media`

Request: `multipart/form-data` · field `file` · form `purpose`

`purpose`: `avatar` | `chat` | `story` | `channel_avatar` | `group_avatar` | `view_once` | `voice` | `document` | `wallpaper`

Response:

```json
{
  "id": "uuid",
  "url": "https://cdn.../file",
  "mime": "image/jpeg",
  "size": 204800,
  "width": 1200,
  "height": 1200,
  "duration_ms": null,
  "purpose": "chat"
}
```

---

## Search

**Required APIs**

- `GET` `/search`
- `GET` `/search/history`
- `DELETE` `/search/history`

---

`GET`: `/search`

Request (query): `q=olivia` · `type=chat|contact|call`

Response:

```json
{
  "items": [
    {
      "id": "uuid",
      "title": "Olivia Williams",
      "subtitle": "Can we sync on the launch plan?",
      "type": "chat",
      "conversation_id": "uuid",
      "user_id": null,
      "call_id": null
    }
  ]
}
```

---

`GET`: `/search/history`

Request: —

Response:

```json
{ "items": ["Olivia Williams", "Design Team"] }
```

---

`DELETE`: `/search/history`

Request: —

Response:

```json
{ "cleared": true }
```

---

## Notifications

**Required APIs**

- `GET` `/notifications`
- `POST` `/notifications/{id}/read`
- `POST` `/notifications/read-all`
- `PATCH` `/me/notification-settings`
- `PUT` `/me/devices`

---

`GET`: `/notifications`

Request (query): `filter=all|unread|mentions|groups`

Response:

```json
{
  "unread_count": 3,
  "items": [
    {
      "id": "uuid",
      "actor": { "id": "uuid", "name": "Olivia Williams", "avatar_url": "https://..." },
      "category": "reaction",
      "title": "Olivia Williams",
      "body": "reacted to your message",
      "unread": true,
      "created_at": "2026-08-27T11:32:00Z",
      "deep_link": { "type": "conversation", "id": "uuid" }
    }
  ]
}
```

`category`: `reaction` | `mention` | `file` | `follow` | `group` | `message` | `call` | `story` | `login`  
`deep_link.type`: `conversation` | `user` | `call` | `story` | `group` | `channel`

---

`POST`: `/notifications/{id}/read`

Request: —

Response:

```json
{ "unread": false }
```

---

`POST`: `/notifications/read-all`

Request: —

Response:

```json
{ "unread_count": 0 }
```

---

`PATCH`: `/me/notification-settings`

Request:

```json
{ "enabled": true }
```

Response:

```json
{ "enabled": true }
```

---

`PUT`: `/me/devices`

Request:

```json
{
  "token": "fcm-or-apns",
  "platform": "ios",
  "app_version": "1.0.0"
}
```

Response:

```json
{ "device_id": "uuid" }
```

---

## Invite Friends

**Required APIs**

- `GET` `/me/invite`
- `POST` `/invites`
- `GET` `/invites/{code}`

---

`GET`: `/me/invite`

Request: —

Response:

```json
{
  "code": "NADEEM8",
  "url": "https://messangerax.app/invite/NADEEM8"
}
```

---

`POST`: `/invites`

Request:

```json
{ "contact_id": "uuid", "channel": "sms" }
```

`channel`: `sms` | `in_app`

Response:

```json
{ "invited": true }
```

---

`GET`: `/invites/{code}`

Request: —

Response:

```json
{ "valid": true, "inviter_name": "Nadeem Hasan" }
```

---

## Support & Legal

**Required APIs**

- `POST` `/support/conversation`
- `GET` `/legal/terms`
- `GET` `/legal/privacy`

---

`POST`: `/support/conversation`

Request: —

Response: conversation object (`name: "Messanger AX Support"`).

---

`GET`: `/legal/terms`

Request: —

Response:

```json
{
  "title": "Terms of Service",
  "body": "plain text or markdown",
  "version": "1.0",
  "updated_at": "2026-08-01T00:00:00Z"
}
```

---

`GET`: `/legal/privacy`

Request: —

Response: same shape as terms.

---

## Realtime

`GET` (WebSocket): `wss://api.messangerax.app/v1/realtime?token={access_token}`

**Client → server**

```json
{ "event": "presence", "payload": { "online": true } }
```

```json
{ "event": "ack", "payload": { "message_id": "uuid", "status": "delivered" } }
```

```json
{ "event": "live_location.ping", "payload": { "share_id": "uuid", "lat": 0, "lng": 0 } }
```

```json
{ "event": "call.signal", "payload": { "call_id": "uuid", "sdp": "...", "type": "offer" } }
```

```json
{ "event": "call.ice", "payload": { "call_id": "uuid", "candidate": {} } }
```

**Server → client**

```json
{ "event": "message.new", "payload": { "conversation_id": "uuid", "message": {} } }
```

```json
{ "event": "message.updated", "payload": { "message": {} } }
```

```json
{ "event": "message.ack", "payload": { "message_id": "uuid", "status": "read" } }
```

```json
{ "event": "conversation.updated", "payload": { "conversation": {} } }
```

```json
{ "event": "unread.updated", "payload": { "conversations": 4, "notifications": 3, "missed_calls": 0 } }
```

```json
{ "event": "presence", "payload": { "user_id": "uuid", "online": true, "last_seen_at": "..." } }
```

```json
{ "event": "notification.new", "payload": { "notification": {} } }
```

```json
{ "event": "story.new", "payload": { "user_id": "uuid" } }
```

```json
{ "event": "live_location.update", "payload": { "share_id": "uuid", "lat": 0, "lng": 0 } }
```

```json
{ "event": "channel.updated", "payload": { "channel": {} } }
```

```json
{ "event": "call.offer", "payload": { "call": {}, "sdp": "..." } }
```

```json
{ "event": "call.answer", "payload": { "call_id": "uuid", "sdp": "..." } }
```

```json
{ "event": "call.end", "payload": { "call_id": "uuid", "reason": "hangup" } }
```

```json
{ "event": "screenshot", "payload": { "conversation_id": "uuid", "user_id": "uuid" } }
```
