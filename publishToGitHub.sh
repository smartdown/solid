#
# Based upon:
#	https://blog.bloomca.me/2017/12/15/how-to-push-folder-to-github-pages.html
#

REMOTE=`git remote get-url --push origin`
rm -rf dist
mkdir dist/
cd dist
# ln -s . solid
cp -r ../public/ ./public/
rm ./public/smartdown/index_solid.html
mv ./public/smartdown/index_github.html ./public/smartdown/index.html
cp ../index_github_root.html ./index.html
touch .nojekyll
ls -laR


git init
git add . .nojekyll
git commit -m "Initial commit"
git remote add origin ${REMOTE}
git push --force origin master:gh-pages
