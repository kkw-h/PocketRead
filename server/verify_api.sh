#!/bin/bash

BASE_URL="http://localhost:8787"

if [ ! -z "$1" ]; then
  BASE_URL="$1"
fi

echo "Testing API at $BASE_URL"
echo "----------------------------------------"

# 1. Test Status
echo "1. GET /api/status"
curl -s "$BASE_URL/api/status" | jq . || curl "$BASE_URL/api/status"
echo ""
echo "----------------------------------------"

# 2. Test Books (GET)
echo "2. GET /api/books"
curl -s "$BASE_URL/api/books" | jq . || curl "$BASE_URL/api/books"
echo ""
echo "----------------------------------------"

# 3. Test Sync (POST) - Upload progress
echo "3. POST /api/sync (Upload Progress)"
TIMESTAMP=$(date +%s)
BOOK_ID="test-book-$(date +%s)"

PAYLOAD=$(cat <<EOF
{
  "progress": [
    {
      "book_id": "$BOOK_ID",
      "chapter_index": 1,
      "percentage": 0.5,
      "device_id": "test-script",
      "updated_at": $TIMESTAMP
    }
  ]
}
EOF
)

echo "Payload: $PAYLOAD"
curl -s -X POST "$BASE_URL/api/sync" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" | jq . || curl -X POST "$BASE_URL/api/sync" -H "Content-Type: application/json" -d "$PAYLOAD"
echo ""
echo "----------------------------------------"

# 4. Test Sync (GET) - Verify progress
echo "4. GET /api/sync?book_id=$BOOK_ID"
curl -s "$BASE_URL/api/sync?book_id=$BOOK_ID" | jq . || curl "$BASE_URL/api/sync?book_id=$BOOK_ID"
echo ""
echo "----------------------------------------"

# 5. Test Upload Book (POST)
echo "5. POST /api/books (Upload Book)"
echo "Dummy content" > dummy.epub
curl -s -X POST "$BASE_URL/api/books" \
  -H "Authorization: Bearer test-key" \
  -F "file=@dummy.epub" \
  -F "title=Test Book" \
  -F "author=Test Author" \
  -F "format=epub" | jq . || curl -X POST "$BASE_URL/api/books" -F "file=@dummy.epub" -F "title=Test Book" -F "author=Test Author"
rm dummy.epub
echo ""
echo "----------------------------------------"
