cd ../docker
docker compose -f docker-compose.middleware.yaml -p dify up -d
cd ../api
nano .env

"
SECRET_KEY=
CONSOLE_API_URL=http://0.0.0.0:5001
CONSOLE_WEB_URL=http://0.0.0.0:3000
SERVICE_API_URL=http://0.0.0.0:5001
APP_WEB_URL=http://0.0.0.0:3000
FILES_URL=http://0.0.0.0:5001
FILES_ACCESS_TIMEOUT=300
CELERY_BROKER_URL=redis://:difyai123456@localhost:6379/1
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_USERNAME=
REDIS_PASSWORD=difyai123456
REDIS_DB=0
DB_USERNAME=postgres
DB_PASSWORD=difyai123456
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=dify
STORAGE_TYPE=local
STORAGE_LOCAL_PATH=storage
S3_USE_AWS_MANAGED_IAM=false
S3_ENDPOINT=https://your-bucket-name.storage.s3.clooudflare.com
S3_BUCKET_NAME=your-bucket-name
S3_ACCESS_KEY=your-access-key
S3_SECRET_KEY=your-secret-key
S3_REGION=your-region
AZURE_BLOB_ACCOUNT_NAME=your-account-name
AZURE_BLOB_ACCOUNT_KEY=your-account-key
AZURE_BLOB_CONTAINER_NAME=yout-container-name
AZURE_BLOB_ACCOUNT_URL=https://<your_account_name>.blob.core.windows.net
ALIYUN_OSS_BUCKET_NAME=your-bucket-name
ALIYUN_OSS_ACCESS_KEY=your-access-key
ALIYUN_OSS_SECRET_KEY=your-secret-key
ALIYUN_OSS_ENDPOINT=your-endpoint
ALIYUN_OSS_AUTH_VERSION=v1
ALIYUN_OSS_REGION=your-region
GOOGLE_STORAGE_BUCKET_NAME=yout-bucket-name
GOOGLE_STORAGE_SERVICE_ACCOUNT_JSON_BASE64=your-google-service-account-json-base64-string
TENCENT_COS_BUCKET_NAME=your-bucket-name
TENCENT_COS_SECRET_KEY=your-secret-key
TENCENT_COS_SECRET_ID=your-secret-id
TENCENT_COS_REGION=your-region
TENCENT_COS_SCHEME=your-scheme
WEB_API_CORS_ALLOW_ORIGINS=http://127.0.0.1:3000,*
CONSOLE_CORS_ALLOW_ORIGINS=http://127.0.0.1:3000,*
VECTOR_STORE=weaviate
WEAVIATE_ENDPOINT=http://localhost:8080
WEAVIATE_API_KEY=WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih
WEAVIATE_GRPC_ENABLED=false
WEAVIATE_BATCH_SIZE=100
QDRANT_URL=http://localhost:6333
QDRANT_API_KEY=difyai123456
QDRANT_CLIENT_TIMEOUT=20
QDRANT_GRPC_ENABLED=false
QDRANT_GRPC_PORT=6334
MILVUS_HOST=127.0.0.1
MILVUS_PORT=19530
MILVUS_USER=root
MILVUS_PASSWORD=Milvus
MILVUS_SECURE=false
RELYT_HOST=127.0.0.1
RELYT_PORT=5432
RELYT_USER=postgres
RELYT_PASSWORD=postgres
RELYT_DATABASE=postgres
TENCENT_VECTOR_DB_URL=http://127.0.0.1
TENCENT_VECTOR_DB_API_KEY=dify
TENCENT_VECTOR_DB_TIMEOUT=30
TENCENT_VECTOR_DB_USERNAME=dify
TENCENT_VECTOR_DB_DATABASE=dify
TENCENT_VECTOR_DB_SHARD=1
TENCENT_VECTOR_DB_REPLICAS=2
PGVECTO_RS_HOST=localhost
PGVECTO_RS_PORT=5431
PGVECTO_RS_USER=postgres
PGVECTO_RS_PASSWORD=difyai123456
PGVECTO_RS_DATABASE=postgres
PGVECTOR_HOST=127.0.0.1
PGVECTOR_PORT=5433
PGVECTOR_USER=postgres
PGVECTOR_PASSWORD=postgres
PGVECTOR_DATABASE=postgres
TIDB_VECTOR_HOST=xxx.eu-central-1.xxx.aws.tidbcloud.com
TIDB_VECTOR_PORT=4000
TIDB_VECTOR_USER=xxx.root
TIDB_VECTOR_PASSWORD=xxxxxx
TIDB_VECTOR_DATABASE=dify
CHROMA_HOST=127.0.0.1
CHROMA_PORT=8000
CHROMA_TENANT=default_tenant
CHROMA_DATABASE=default_database
CHROMA_AUTH_PROVIDER=chromadb.auth.token_authn.TokenAuthenticationServerProvider
CHROMA_AUTH_CREDENTIALS=difyai123456
OPENSEARCH_HOST=127.0.0.1
OPENSEARCH_PORT=9200
OPENSEARCH_USER=admin
OPENSEARCH_PASSWORD=admin
OPENSEARCH_SECURE=true
UPLOAD_FILE_SIZE_LIMIT=15
UPLOAD_FILE_BATCH_LIMIT=5
UPLOAD_IMAGE_FILE_SIZE_LIMIT=10
MULTIMODAL_SEND_IMAGE_FORMAT=base64
MAIL_TYPE=
MAIL_DEFAULT_SEND_FROM=no-reply <no-reply@dify.ai>
RESEND_API_KEY=
RESEND_API_URL=https://api.resend.com
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=465
SMTP_USERNAME=123
SMTP_PASSWORD=abc
SMTP_USE_TLS=true
SMTP_OPPORTUNISTIC_TLS=false
SENTRY_DSN=
DEBUG=false
SQLALCHEMY_ECHO=false
NOTION_INTEGRATION_TYPE=public
NOTION_CLIENT_SECRET=you-client-secret
NOTION_CLIENT_ID=you-client-id
NOTION_INTERNAL_SECRET=you-internal-secret
ETL_TYPE=dify
UNSTRUCTURED_API_URL=
UNSTRUCTURED_API_KEY=
SSRF_PROXY_HTTP_URL=
SSRF_PROXY_HTTPS_URL=
BATCH_UPLOAD_LIMIT=10
KEYWORD_DATA_SOURCE_TYPE=database
CODE_EXECUTION_ENDPOINT=http://127.0.0.1:8194
CODE_EXECUTION_API_KEY=dify-sandbox
CODE_MAX_NUMBER=9223372036854775807
CODE_MIN_NUMBER=-9223372036854775808
CODE_MAX_STRING_LENGTH=80000
TEMPLATE_TRANSFORM_MAX_LENGTH=80000
CODE_MAX_STRING_ARRAY_LENGTH=30
CODE_MAX_OBJECT_ARRAY_LENGTH=30
CODE_MAX_NUMBER_ARRAY_LENGTH=1000
API_TOOL_DEFAULT_CONNECT_TIMEOUT=10
API_TOOL_DEFAULT_READ_TIMEOUT=60
HTTP_REQUEST_MAX_CONNECT_TIMEOUT=300
HTTP_REQUEST_MAX_READ_TIMEOUT=600
HTTP_REQUEST_MAX_WRITE_TIMEOUT=600
HTTP_REQUEST_NODE_MAX_BINARY_SIZE=10485760 # 10MB
HTTP_REQUEST_NODE_MAX_TEXT_SIZE=1048576 # 1MB
LOG_FILE=
INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH=1000
WORKFLOW_MAX_EXECUTION_STEPS=500
WORKFLOW_MAX_EXECUTION_TIME=1200
WORKFLOW_CALL_MAX_DEPTH=5
APP_MAX_EXECUTION_TIME=1200
"
