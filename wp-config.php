<?php

/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'salt');

/** MySQL database username */
define('DB_USER', 'salt');

/** MySQL database password */
define('DB_PASSWORD', 'saltpass');

/** MySQL hostname */
define('DB_HOST', 'mysql');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */

define('AUTH_KEY',         '0ae4c816cc178bb23395e7defa6ecde0b86a3004');
define('SECURE_AUTH_KEY',  'e7b80ef50dd0199f7098218a65d7de22342d1418');
define('LOGGED_IN_KEY',    'b6935925a35c32e9602b9f99390c19a138236848');
define('NONCE_KEY',        '96085f86dc876f27c0bc7e391e96fb436989418d');
define('AUTH_SALT',        '6cb64cecccadff930aa8f756fa6bd6749df8ac76');
define('SECURE_AUTH_SALT', '70ceba243f6c2c4469882ba4ca366231e406b67f');
define('LOGGED_IN_SALT',   '55b8f7ac2ac96546543508def1f0d9bf1ad633b8');
define('NONCE_SALT',       'a70253bf341d940bd2cef00f1a710b460daeabba');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', true);
if (WP_DEBUG) {
    define('WP_DEBUG_LOG', true);
    define('WP_DEBUG_DISPLAY', true);
    @ini_set('display_errors', 0);
}

// If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact
// see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$_SERVER['HTTPS'] = 'on';
}

// Manual init of $_SERVER variables for Docker environment
$_SERVER['SERVER_NAME'] = 'localhost';
$_SERVER["SERVER_PORT"] = 8080;

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
