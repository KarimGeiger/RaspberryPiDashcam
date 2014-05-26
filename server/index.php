<?php
/**
 * Basic API for Dashcam communication
 */

define('SAVE_FILE', '/saveflag.txt');

if (isset($_GET['get'])) {
    switch ($_GET['get']) {
        case 'save':
            if (getAndRemoveSaveFlag()) {
                echo 'save';
            } else {
                echo 'continue';
            }
            break;
    }
} elseif (isset($_GET['set'])) {
    switch ($_GET['set']) {
        case 'save':
            setSaveFlag();
            echo 'ok';
            break;
    }
}

function setSaveFlag() {
    file_put_contents(__DIR__ . SAVE_FILE, '1');
}

function getAndRemoveSaveFlag() {
    $saveflag = file_get_contents(__DIR__ . SAVE_FILE);
    file_put_contents(__DIR__ . SAVE_FILE, '0');

    if (strpos($saveflag, 1) !== false) {
        return true;
    }
    return false;
}
