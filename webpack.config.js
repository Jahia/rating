const path = require('path');
const {CleanWebpackPlugin} = require('clean-webpack-plugin');
const {ProvidePlugin} = require('webpack');
const packageJson = require('./package.json');

module.exports = (env, argv) => {
    const appsFolder = 'src/main/resources/javascript/apps';
    return {
        mode: argv.mode ? argv.mode : 'development',
        entry: {
            main: path.resolve(__dirname, 'src/javascript/index')
        },
        output: {
            path: path.resolve(__dirname, appsFolder),
            filename: `${packageJson.name}.bundle.js`,
            library: 'RatingLibrary'
        },
        module: {
            rules: [
                {
                    test: /\.css$/i,
                    use: ["style-loader","css-loader"],
                }
            ]
        },
        plugins: [
            new ProvidePlugin({
                'window.jQuery': 'jquery',
                'window.$': 'jquery',
                'jQuery': 'jquery',
                '$': 'jquery',
            }),
            new CleanWebpackPlugin({
                cleanOnceBeforeBuildPatterns: [`${path.resolve(__dirname, appsFolder)}/**/*`],
                verbose: false
            })
        ]
    };
}
