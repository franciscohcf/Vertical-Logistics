# Vertical Logistics API

## Overview

A Rails API for processing and managing order entries from text ledger files.

## Technology Stack

- **Language**: Ruby 3.4.1
- **Framework**: Rails 8.0 (API mode)
- **Database**: SQLite
- **Testing**: RSpec
- **Containerization**: Docker

## API Endpoints

### 1. Upload Order Entries
- **Endpoint**: `POST /order_entries`
- **Request Type**: Multipart Form-Data
- **File Key**: `file`
- **Curl Example**:
  ```bash
  curl -X POST \
    -F "file=@/path/to/ledger_file.txt" \
    http://localhost:3000/order_entries
  ```
- **Request Clients**:
  - Select `multipart/form-data`
  - Add key `file`
  - Attach text file as the value
- **Success Response**:
  ```json
  {
    "message": "Order entries processed successfully",
    "processing_time": 0.25
  }
  ```
- **Supported File Type**: Plain Text (.txt)

### 2. Retrieve All Orders
- **Endpoint**: `GET /orders`
- **Example Request**:
  ```bash
  curl http://localhost:3000/orders
  ```
- **Success Response**:
  ```json
  [
    {
      "user_id": 99,
      "name": "Junita Jast",
      "orders": [
        {
          "order_id": 1053,
          "total": "747.91",
          "date": "2021-10-27",
          "products": [
            {
              "product_id": 4,
              "value": "747.91"
            }
          ]
        }
      ]
    }
  ]
  ```

### 3. Get Specific Order
- **Endpoint**: `GET /orders/:id`
- **Example Request**:
  ```bash
  curl http://localhost:3000/orders/1053
  ```
- **Success Response**:
  ```json
  {
    "user_id": 99,
    "name": "Junita Jast",
    "order": {
      "order_id": 1053,
      "total": "747.91",
      "date": "2021-10-27",
      "products": [
        {
          "product_id": 4,
          "value": "747.91"
        }
      ]
    }
  }
  ```

### 4. Filter Orders by Date Range
- **Endpoint**: `GET /orders/by_period`
- **Example Request**:
  ```bash
  curl "http://localhost:3000/orders/by_period?start_date=2021-06-01&end_date=2021-07-31"
  ```
- **Success Response**:
  ```json
  [
    {
      "user_id": 99,
      "name": "Junita Jast",
      "orders": [
        {
          "order_id": 1053,
          "total": "747.91",
          "date": "2021-06-27",
          "products": [...]
        }
      ]
    }
  ]
  ```

## Quick Start

### Prerequisites
- Docker and Docker Compose

### Setup
```bash
docker compose build
```

### Testing

Start with the following command to access the container terminal:
```bash
make bash
```

Once inside the container run:
```bash
rspec
```

### Start Server

Start with the following command to access the container terminal:
```bash
make bash
```

Once inside the container run:
```bash
rails s -p 3000 -b 0.0.0.0
```

Now the server will be running on the container ;)
