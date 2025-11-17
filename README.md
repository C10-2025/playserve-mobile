# 🎾 PlayServe
Aplikasi kami bernama PlayServe, sebuah aplikasi yang dirancang khusus untuk para penggemar tennis dengan tambahan elemen gamification. Aplikasi akan menyediakan beberapa fitur untuk pemain tennis, mulai dari pengelolaan profil pribadi dengan sistem rank yang disesuaikan dari banyak kemenangan, pencarian pasangan bermain berdasarkan rank dan radius lokasi, pemesanan lapangan secara online, komunitas untuk berbagi informasi, hingga ulasan lapangan yang membantu pemain lain dalam memilih tempat bermain.

## 📑 Daftar Isi
- [Anggota Kelompok](#anggota-kelompok)
- [Modul](#modul)
- [Jenis Pengguna Aplikasi](#jenis-pengguna-aplikasi)
- [Link](#link)

## 👥 Anggota Kelompok
1. Annisa Fakhira Cendekia - 2406354606
2. Deltakristiano Kurniaputra - 2406425810
3. Jonathan Yitskhaq Rundjan - 2406435231
4. Marco Imanuel - 2406411824
5. Muhammad Nadhif Ibrahim - 2406398324

## 📦 Modul

### 1. Profile untuk identitas setiap pengguna (Annisa Fakhira Cendekia).
- Informasi dasar seperti username, nama, lokasi (drop-down), media sosial, nomor telepon, email.
- Menyediakan 5 avatar untuk profile.
- Rank pemain yang ditentukan berdasarkan jumlah kemenangan.

### 2. Match Making untuk membantu pengguna menemukan lawan main yang sesuai baik berdasarkan rank dan radius lokasi (Muhammad Nadhif Ibrahim).  
- Algoritma pencocokan berdasarkan level keterampilan dan lokasi.
- Rekomendasi otomatis pemain yang sedang mencari partner. Apabila match diterima maka akan diberikan informasi profilenya dan dapat berlanjut di sosial media masing-masing pemain.

### 3. Booking Lapangan (player) dan Add New Field (admin) untuk reservasi lapangan tennis secara online serta menambahkan pilihan lapangan (Deltakristiano Kurniaputra).
- Pencarian lapangan berdasarkan lokasi, harga, dan kategori lainnya.
- Kalender ketersediaan lapangan.
- Penambahan lapangan baru oleh admin.

### 4. Community untuk berbagi informasi dalam suatu komunitas di satu lapangan (Jonathan Yitskhaq Rundjan).
- Pencarian community.
- Sistem post dan reply yang dikhususkan untuk anggota community.
- Community dibuat dan dihapus oleh admin.

### 5. Review untuk berbagi pengalaman bermain di suatu lapangan (Marco Imanuel).
- Sistem rating dengan angka dan komentar.
- Sistem sorting untuk rating dari review.

## 👤 Jenis Pengguna aplikasi
1. Admin untuk menambahkan lapangannya agar dapat reservasi secara online. Selain itu, admin dapat menambahkan dan menghapus community ataupun profile user yang melanggar aturan.
2. Player, role untuk para penggemar tennis. Semua fitur selain Add New Field pada daftar modul dimiliki oleh player.


## Alur Pengintegrasian dengan Web Service

1. Aplikasi Django menyediakan REST API yang mengembalikan data dalam format JSON.
2. Flutter mengirim request HTTP ke endpoint API Django menggunakan package seperti `http`.
3. Django memproses request, menjalankan logika bisnis, dan mengambil data dari database.
4. Django mengembalikan respons JSON ke Flutter.
5. Flutter mem-parsing respons tersebut lalu menampilkan hasilnya di UI.

Alur ini memungkinkan aplikasi terhubung dan berinteraksi dengan aplikasi web Django yang telah dibuat sebelumnya.

## 🔗 Link
- [Dataset](https://catalog.data.gov/dataset/tennis-courts)
- [Design](https://www.figma.com/design/Ov2RsMYx9U1vhZXtw1lSY4/UI-UX-WEB?node-id=0-1&t=r3axZEDkETmZLSoK-1)