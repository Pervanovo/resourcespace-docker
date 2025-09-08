<?php
###############################
## ResourceSpace
## Local Configuration Script
###############################

# All custom settings should be entered in this file.
# Options may be copied from config.default.php and configured here.

# MySQL database settings
$mysql_server = getenv('MYSQL_SERVER');
$mysql_username = getenv('MYSQL_USER');
$mysql_password = getenv('MYSQL_PASSWORD');
$mysql_db = getenv('MYSQL_DB') ?: 'resourcespace';

$mysql_bin_path = '/usr/bin';

# Base URL of the installation
$baseurl = getenv('BASEURL') ?: 'http://localhost';

# SMTP settings
if (getenv('SMTP_HOST')) {
    $use_smtp = true;
    $use_phpmailer = true;
    $smtp_secure = getenv('SMTP_SECURE');
    $smtp_host = getenv('SMTP_HOST');
    $smtp_port = getenv('SMTP_PORT');
    if (getenv('SMTP_PASSWORD')) {
        $smtp_auth = true;
        $smtp_username = getenv('SMTP_USERNAME');
        $smtp_password = getenv('SMTP_PASSWORD');
    }
}

# Email settings
$email_notify = getenv('EMAIL_NOTIFY');
$email_from = getenv('EMAIL_FROM');
# Secure keys
$scramble_key = getenv('SCRAMBLE_KEY');
$api_scramble_key = getenv('API_SCRAMBLE_KEY');

# Paths
$php_path = '/usr/bin';
$imagemagick_path = '/usr/bin';
$ghostscript_path = '/usr/bin';
$ffmpeg_path = '/usr/bin';
$exiftool_path = '/usr/bin';
$antiword_path = '/usr/bin';
$pdftotext_path = '/usr/bin';

$applicationname = getenv('APP_NAME') ?: 'ResourceSpace';
$homeanim_folder = 'filestore/system/slideshow';

/*

New Installation Defaults
-------------------------

The following configuration options are set for new installations only.
This provides a mechanism for enabling new features for new installations without affecting existing installations (as would occur with changes to config.default.php)

*/
                                
// Set imagemagick default for new installs to expect the newer version with the sRGB bug fixed.
$imagemagick_colorspace = "sRGB";

$contact_link=false;
$themes_simple_view=true;

$stemming=true;
$case_insensitive_username=true;
$user_pref_user_management_notifications=true;
$themes_show_background_image = true;

$use_zip_extension=true;
$collection_download=true;

$ffmpeg_preview_force = true;
$ffmpeg_preview_extension = 'mp4';
$ffmpeg_preview_options = '-f mp4 -b:v 1200k -b:a 64k -ac 1 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3 -c:a aac -strict -2';

$daterange_search = true;
if (getenv('UPLOAD_THEN_PROCESS')) {
    // New upload mode that focuses on getting files into the filestore, then working off a queue for further processing (metadata extract, preview creation, etc).
    // requires $offline_job_queue=true;
    $upload_then_process = true;

    // Uncomment and set to an archive state where $upload_then_process files are stored before processing.
    // It is strongly recommended that a unique archive state be created to handle this
    $upload_then_process_holding_state = -3;
    $lang['status-3'] = "Pending upload processing";
} else {
    // New mode that means the upload goes first, then the users edit and approve resources moving them to the correct stage.
    $upload_then_edit = true;
}

$purge_temp_folder_age=90;
$filestore_evenspread=true;

$comments_resource_enable=true;

$api_upload_urls = array();

$use_native_input_for_date_field = true;
$resource_view_use_pre = true;

$sort_tabs = false;
$maxyear_extends_current = 5;
$thumbs_display_archive_state = true;
$featured_collection_static_bg = true;
$file_checksums = true;
$hide_real_filepath = true;

$plugins[] = "brand_guidelines";

# Custom config
if (getenv('ALLOWED_EXTERNAL_SHARE_GROUPS')) {
    $allowed_external_share_groups = explode(",", getenv('ALLOWED_EXTERNAL_SHARE_GROUPS'));
}
// Adds an option to the upload page which allows Resources Uploaded together to all be related
/* requires $enable_related_resources=true */
/* $php_path MUST BE SET */
$relate_on_upload = true;

$show_detailed_errors = true;

if (getenv('DEBUG')) {
    $debug_extended_info = true;
    $debug_log = true;
    $debug_log_location = "/var/log/apache2/error.log";
}

if (getenv('UPPY_COMPANION_URL')) {
    $uppy_companion_url = getenv('UPPY_COMPANION_URL');
    if (getenv('UPPY_PLUGINS')) {
        $uppyPlugins = explode(",", getenv('UPPY_PLUGINS'));
        foreach ($uppyPlugins as $uppyPlugin) {
            $uploader_plugins[] = $uppyPlugin;
        }
    }
}

$offline_job_queue = true;

// Optional folder to use for temporary file storage.
// If using a remote filestore for resources e.g. a NAS this should be added to point to a local drive with fast disk access
$tempdir = '/tmp/resourcespace';

if (getenv('UPLOAD_DISK_QUOTA_WARNING')) {
    // GB of disk space left before uploads are disabled.
    // This causes disk space to be checked before each upload attempt
    $disk_quota_limit_size_warning_noupload = intval(getenv('UPLOAD_DISK_QUOTA_WARNING'));
}

if (getenv('UPLOAD_CONCURRENT_LIMIT')) {
    $upload_concurrent_limit = intval(getenv('UPLOAD_CONCURRENT_LIMIT'));
}
