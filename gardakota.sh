#!/bin/bash

# ====== SETTING AWAL ======
# default remote & branch (kalau mau dipaksa ke main, isi ORIGIN_BRANCH="main")
ORIGIN_NAME="origin"
ORIGIN_BRANCH=""

# ====== CEK GIT REPO ======
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Bukan folder git. Jalankan script ini di dalam repo gardakotaidaman.github.io"
  exit 1
fi

# ====== HAPUS FILE SAMPAH (.DS_Store) ======
echo "Menghapus file .DS_Store..."
find . -name ".DS_Store" -type f -delete

# Pastikan .DS_Store di-ignore ke depan
if ! grep -q ".DS_Store" .gitignore 2>/dev/null; then
  echo ".DS_Store" >> .gitignore
fi

# ====== TAMPILKAN STATUS ======
echo
echo "Status git sebelum commit:"
git status

# ====== INPUT PESAN COMMIT ======
echo
read -p "Isi pesan commit (kosongkan untuk auto timestamp): " COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
  COMMIT_MSG="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# ====== ADD & COMMIT ======
echo
echo "Menjalankan git add ."
git add .

# Cek apakah ada perubahan yang benar‑benar perlu di-commit
if git diff --cached --quiet; then
  echo "Tidak ada perubahan untuk di-commit. Selesai."
  exit 0
fi

echo "Menjalankan git commit -m \"$COMMIT_MSG\""
git commit -m "$COMMIT_MSG"

# ====== TENTUKAN BRANCH ======
if [ -z "$ORIGIN_BRANCH" ]; then
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
else
  CURRENT_BRANCH="$ORIGIN_BRANCH"
fi

# ====== PULL (REBASE) SEBELUM PUSH ======
echo
echo "Menjalankan git pull --rebase $ORIGIN_NAME $CURRENT_BRANCH"
git pull --rebase "$ORIGIN_NAME" "$CURRENT_BRANCH"

# ====== PUSH ======
echo
echo "Menjalankan git push $ORIGIN_NAME $CURRENT_BRANCH"
git push "$ORIGIN_NAME" "$CURRENT_BRANCH"

echo
echo "Selesai. Perubahan sudah di-push ke $ORIGIN_NAME/$CURRENT_BRANCH"
