#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run build

# navigate into the build output directory
cd dist

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

# Initialize a new Git repository if one does not exist
if [ ! -d .git ]; then
  git init
fi

# Check if 'main' branch exists, create it if not
if ! git show-ref --quiet refs/heads/main; then
  git checkout -b main
else
  git checkout main
fi

# Add all changes to the repository and commit
git add -A
git commit -m 'deploy'

# Force push to the gh-pages branch on GitHub
git push -f https://github.com/andersonpereiradossantos/calculadora-antecipacao-parcelas.git main:gh-pages

# Go back to the previous directory
cd -
