# Prodify Docker Compose Project

## Ikhtisar

Prodify adalah infrastruktur produksi lokal yang disiapkan menggunakan Docker Compose. Ini mencakup berbagai layanan penting seperti PostgreSQL, MongoDB, Minio, Camunda, Redis, dan Mailpit. Layanan ini dikonfigurasi dengan volume yang dipetakan ke folder penyimpanan proyek untuk data yang persisten.

## Prasyarat

- Docker
- Docker Compose

## Memulai

### Clone Repository

```sh
git clone <repository-url>
cd prodify
```

### Variabel Lingkungan (Optional)

> Sebelum melakukan step ini, pastikan kalian paham dulu terkait infrastructure, ya!
> Kalau tidak, gunakan konfigurasi default saja.

Buat file `.env` di direktori root proyek dan konfigurasikan variabel lingkungan berikut sesuai kebutuhan:

```env
# PostgreSQL
PGPASSWORD=secreted
DB_USER=user
DB_PASSWORD=secret
DB_NAME=camunda
DB_PORT=5432

# MongoDB
MONGO_PORT=27017

# Minio
MINIO_USER=minioadmin
MINIO_PASSWORD=minioadmin
MINIO_PORT=9000
MINIO_CONSOLE_PORT=8900

# Camunda
CAMUNDA_PORT=8080

# Matomo
MATOMO_PORT=8081

# Mailpit
MAIL_SERVER_PORT=1025
MAIL_ADMIN_PORT=8025
```

### Mulai Layanan

```sh
docker-compose up -d
```

### Setup Camunda

Buka halaman Camunda (default: [`localhost:8080`](http://localhost:8080/camunda/app/admin/default/setup/#/setup)) dan konfigurasikan Camunda menggunakan pengaturan berikut:

- User Account: `admin` / `admin` atau _value_ lainnya
- User Profile: `Admin` / `Admin` atau _value_ lainnya

### Deploy BPMN

- Buka berkas BPMN di aplikasi Camunda Modeler
- Sesuaikan versinya jika belum sesuai
- Deploy BPMN ke Camunda Engine (default: `http://localhost:8080/engine-rest`)

## Layanan dan Konfigurasi

### PostgreSQL

- **Image**: postgres:latest
- **Port**: 5432 (dapat dikonfigurasi)
- **Volume**:
  - `./storage/postgres_data:/var/lib/postgresql/data`
  - Skrip SQL di direktori `./pgsql/` untuk inisialisasi database
- **Healthcheck**: Memastikan layanan PostgreSQL siap sebelum layanan yang bergantung memulai.

### MongoDB

- **Image**: mongo:latest
- **Port**: 27017 (dapat dikonfigurasi)
- **Volume**: `./storage/mongo_data:/data/db`

### Minio

- **Image**: minio/minio:latest
- **Port**: 9000 (dapat dikonfigurasi), 8900 (console port, dapat dikonfigurasi)
- **Perintah**: `minio server /data/minio --console-address ":8900"`
- **Volume**: `./storage/minio_data:/data`

### Camunda

- **Image**: camunda/camunda-bpm-platform:7.19.0
- **Port**: 8080 (dapat dikonfigurasi)
- **Bergantung pada**: Layanan PostgreSQL
- **Lingkungan**:
  - `DB_DRIVER`: org.postgresql.Driver
  - `DB_URL`: jdbc:postgresql://pgsql:5432/camunda
  - `DB_USERNAME`: ${DB_USER}
  - `DB_PASSWORD`: ${DB_PASSWORD}
- **Volume**:
  - `camunda:/camunda`
  - `./storage/camunda_data:/camunda/webapps/camunda-invoice`

### Matomo

- **Image**: matomo:latest
- **Port**: 8081 (dapat dikonfigurasi)
- **Lingkungan**:
  - `MATOMO_DATABASE_HOST`: pgsql
  - `MATOMO_DATABASE_ADAPTER`: pgsql
  - `MATOMO_DATABASE_USERNAME`: ${DB_USER}
  - `MATOMO_DATABASE_PASSWORD`: ${DB_PASSWORD}
  - `MATOMO_DATABASE_DBNAME`: matomo
- **Volume**: `./storage/matomo_data:/var/www/html:z`

### Redis

- **Image**: redis:latest
- **Port**: 6379
- **Volume**: `./storage/redis_data:/data`

### Mailpit

- **Image**: axllent/mailpit:latest
- **Port**: 1025 (dapat dikonfigurasi), 8025 (dapat dikonfigurasi)
- **Port Tambahan**: ${MAIL_SERVER_PORT}, ${MAIL_ADMIN_PORT}

### Metabase

- **Image**: metabase/metabase:latest
- **Port**: 3000 (dapat dikonfigurasi)
- **Port Tambahan**: ${METABASE_PORT}

## Volume

- `camunda`: Volume lokal untuk data Camunda.

## Menghentikan Layanan
Untuk menghentikan dan menghapus semua container yang berjalan:
```sh
docker-compose down
```

## Mengakses Layanan (Default)

- **PostgreSQL**: `localhost:5432`
- **MongoDB**: `localhost:27017`
- **Minio Console**: `localhost:8900`
- **Camunda**: `localhost:8080`
- **Matomo**: `localhost:8081`
- **Redis**: `localhost:6379`
- **Mailpit Admin**: `localhost:8025`
- **Mailpit SMTP**: `localhost:1025`
- **Metabase**: `localhost:3000`

## Persistensi Data

Data untuk setiap layanan disimpan di direktori `./storage` untuk memastikan persistensi di antara restart container.

## Lisensi

Proyek ini dilisensikan di bawah Lisensi MIT.

## Kontribusi

Kontribusi sangat diterima! Silakan buka issue atau kirim pull request.

## Kontak

Untuk pertanyaan atau pertanyaan lebih lanjut, silakan hubungi Rama di [rama@javan.co.id](mailto:rama@javan.co.id).
