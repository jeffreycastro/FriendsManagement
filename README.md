# README

* Deployment instructions
	1. clone the repo
	2. run `docker-compose up -d`
	3. server should be available afterwards on `http://localhost:3000`

---
# API documentation:

### 1. Connect friends  
**Description**: Creates a friend connection between two users via their email addresses  
**Type**: POST  
**Endpoint**: `http://localhost:3000/api/v1/friendship_management/connect_friends`  
**Input Parameters**:

```
{
  friends:
    [
      'andy@example.com',
      'john@example.com'
    ]
}
```

**Sample Output on success**:

```
{
  "success": true
}
```

**Sample Output on failure**:

```
{
    "success": false,
    "messages": [
        "Email has invalid format",
        "Email can't be blank"
    ]
}
```
> The "messages" array will list the reason/s that caused failure

**List of Possible errors/reasons to fail**:  
1. No input parameters given  
2. Given email addresses are already friends  
3. Given email addresses are the same  
4. One or both email addresses have invalid format  
5. One or both email addresses are blank  
6. User is blocked from making a friend connection  

---
### 2. Friends List
**Description**: Returns the friend list for a given email address  
**Type**: GET  
**Endpoint**: `http://localhost:3000/api/v1/friendship_management/friends_list`  
**Input Parameters**:

```
{
  email: 'andy@example.com'
}
```

**Sample Output on success**:

```
{
  "success": true,
  "friends" :
    [
      'john@example.com'
    ],
  "count" : 1   
}
```

**Sample Output on failure**:

```
{
    "success": false,
    "messages": [
        "User with given email does not exist"
    ]
}
```
> The "messages" array will list the reason/s that caused failure

**List of Possible errors/reasons to fail**:  
1. No input parameters given  
2. Given email address does not have a record on the system yet  

---
### 3. Common Friends List
**Description**: Returns the common friends list between two email addresses  
**Type**: GET  
**Endpoint**: `http://localhost:3000/api/v1/friendship_management/common_friends_list`  
**Input Parameters**:

```
{
  friends:
    [
      'andy@example.com',
      'john@example.com'
    ]
}
```

**Sample Output on success**:

```
{
  "success": true,
  "friends" :
    [
      'common@example.com'
    ],
  "count" : 1   
}
```

**Sample Output on failure**:

```
{
    "success": false,
    "messages": [
        "Duplicate emails given"
    ]
}
```
> The "messages" array will list the reason/s that caused failure

**List of Possible errors/reasons to fail**:  
1. No input parameters given  
2. One or both the given email addresses does not have a record on the system yet  
3. Duplicate email addresses given

---
### 4. Subscribe for updates
**Description**: Subscribe to updates from an email address  
**Type**: POST  
**Endpoint**: `http://localhost:3000/api/v1/friendship_management/subscribe`  
**Input Parameters**:

```
{
  "requestor": "lisa@example.com",
  "target": "john@example.com"
}
```

**Sample Output on success**:

```
{
  "success": true
}
```

**Sample Output on failure**:

```
{
    "success": false,
    "messages": [
        "cannot subscribe to self!"
    ]
}
```
> The "messages" array will list the reason/s that caused failure

**List of Possible errors/reasons to fail**:  
1. No input parameters given  
2. Requestor is already subscribed to the target  
3. Duplicate email addresses given  
4. One or both email addresses have invalid format  
5. One or both email addresses are blank

---
### 5. Block updates
**Description**: Blocks updates from an email address  
**Type**: POST  
**Endpoint**: `http://localhost:3000/api/v1/friendship_management/block`  
**Input Parameters**:

```
{
  "requestor": "andy@example.com",
  "target": "john@example.com"
}
```

**Sample Output on success**:

```
{
  "success": true
}
```

**Sample Output on failure**:

```
{
    "success": false,
    "messages": [
        "Email has invalid format",
        "Email can't be blank"
    ]
}
```
> The "messages" array will list the reason/s that caused failure

**List of Possible errors/reasons to fail**:  
1. No input parameters given  
2. Duplicate email addresses given  
3. One or both email addresses have invalid format  
4. One or both email addresses are blank

---
### 6. Updates recipient list
**Description**: Returns all email addresses that receive updates from a given email address  
**Type**: GET  
**Endpoint**: `http://localhost:3000/api/v1/friendship_management/recipients_list`  
**Input Parameters**:

```
{
  "sender":  "john@example.com",
  "text": "Hello World! kate@example.com"
}
```

**Sample Output on success**:

```
{
  "success": true
  "recipients":
    [
      "lisa@example.com",
      "kate@example.com"
    ]
}
```

**Sample Output on failure**:

```
{
    "success": false,
    "messages": [
        "User with given email does not exist"
    ]
}
```
> The "messages" array will list the reason/s that caused failure

**List of Possible errors/reasons to fail**:  
1. No input parameters given  
2. Given email address does not have a record on the system yet