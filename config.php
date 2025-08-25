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
$upload_then_edit = true;

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
$relate_on_upload = true;
//if (getenv('DEBUG')) {
    $show_detailed_errors = true;
    $debug_extended_info = true;
    $debug_log = true;
    $debug_log_location = "/var/log/apache2/error.log";
//}