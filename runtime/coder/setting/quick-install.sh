cd CRM
cp BuildConfig.json.example BuildConfig.json
chmod +x ./travis-ci/*.sh
chmod +x ./scripts/*.sh
cd src
find . -type d -exec chmod -R 755 {} \;
find . -type f -exec chmod -R 644 {} \;
cd ../..
chown -R coder:coder CRM
cd CRM
npm install --unsafe-perm
npm audit fix
npm run composer-install
npm run orm-gen
npm run build-react
npm run update-signatures
cd ..
