cd CRM
npm install --unsafe-perm
npm audit fix
npm run composer-install
npm run orm-gen
npm run build-react
npm run update-signatures
cd ..
