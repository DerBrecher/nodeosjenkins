echo " === Checking requirements ..."

if [ -x "$(command -v node)" ]
then
    echo "= Node.js installed ... OK" 
else
    echo "ERROR: Cant find node.js, please install it! :: https://nodejs.org"
    exit 1;
fi

if [ -x "$(command -v npm)" ]
then
    echo " = npm installed ... OK" 
else
    echo "ERROR: Cant find npm, please install it! :: https://nodejs.org"
    exit 1;
fi

if [ -x "$(command -v rsync)" ]
then
    echo " = rsync available ... OK"
else
    echo "WARN: Cant find rsync, try to install..."
    cp -r ./.vscode/winmingw/usr /
    if [ -x "$(command -v rsync)" ]
    then
        echo " = rsync available ... OK"
    else
        echo "ERROR: rsync not available, please install ..."
    fi
fi

echo "=== Starting install phase ..."
if [ "$(uname -o)" == "Msys" ]
then
        echo "WARN: Found Msys / Windows / GitBash: Switching to root (/) for install..."
        cd /
fi

echo " = install rollup (all in one JS and root-build-provider :: config = rollup.config.js )"
npm install rollup
echo " = install babel (browser compatibility :: config = babel.config.js)"
npm install rollup-plugin-babel
echo " = install terser (compression / uglify)"
npm install rollup-plugin-terser
echo " = install progress (build logging)"
npm install rollup-plugin-progress

if [ "$(uname -o)" == "Msys" ]
then
        echo "WARN: Found Msys / Windows / GitBash: Switching back..."
        cd -
fi

echo " = install babel core (browser compatibility :: config = babel.config.js)"
npm install --save-dev @babel/core @babel/cli @babel/preset-env
npm install --save @babel/polyfill

echo " === Logging Versions === "
echo " - node:"
node -v
echo " - npm:"
npm -v
echo " - rollup:"
rollup -v
echo " --- babel:"
npm list rollup-plugin-babel
echo " --- terser:"
npm list rollup-plugin-terser
echo " - babel:"
babel --version
echo " - terser:"
terser --version

echo " === Starting build now ..."
echo " = Clear old files"
rm -rf ./target

echo " = Prepare"
mkdir ./target

echo " = Copy resources"
rsync -r * ./target --exclude '*.js' --exclude '.*' --exclude 'target' --exclude '*.sh' --exclude '*.md'

echo " = Perform build through rollup with rollup.config.js"
rollup -c

echo " = Build finished = "