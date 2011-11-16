<?php

/**
* Implements hook_form_FORM_ID_alter().
*
* Allows the profile to alter the site configuration form.
*/
function jbasic_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
}

function jbasic_install_tasks($install_state) {
// Set the default theme
$tasks['default_theme'] = array(
'display_name' => st('Set Default Theme'),
'display' => TRUE,
'type' => 'normal',
'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
'function' => 'jbasic_set_default_theme',
);

// Set the default theme
$tasks['wysiwyg_editor'] = array(
'display_name' => st('WYSIWYG Editor Setup'),
'display' => TRUE,
'type' => 'normal',
'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
'function' => 'jbasic_set_wysiwyg_buttons',
);

// Setup a contact form link
$tasks['contact_form'] = array(
'display_name' => st('Setup Contact Form'),
'display' => TRUE,
'type' => 'normal',
'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
'function' => 'jbasic_set_contact_form',
);

return $tasks;
}

function jbasic_set_default_theme() {
theme_enable(array('theme_default' => 'jlweb'));
variable_set('theme_default', 'jlweb');
theme_disable(array('bartik'));
}

function jbasic_set_wysiwyg_buttons() {
$wysiwyg_settings = array (
'default' => 1,
'user_choose' => 0,
'show_toggle' => 1,
'theme' => 'advanced',
'language' => 'en',
'buttons' =>
array (
'default' =>
array (
'Bold' => 1,
'Italic' => 1,
'Underline' => 1,
'Strike' => 1,
'JustifyLeft' => 1,
'JustifyCenter' => 1,
'JustifyRight' => 1,
'JustifyBlock' => 1,
'BulletedList' => 1,
'NumberedList' => 1,
'Outdent' => 1,
'Indent' => 1,
'Link' => 1,
'Unlink' => 1,
'Image' => 1,
'Source' => 1,
'HorizontalRule' => 1,
'PasteText' => 1,
'RemoveFormat' => 1,
'SpecialChar' => 1,
'Format' => 1,
'Table' => 1,
'Find' => 1,
'Replace' => 1,
'SpellChecker' => 1,
'Scayt' => 1,
),
'imce' =>
array (
'imce' => 1,
),
'drupal' =>
array (
'break' => 1,
),
),
'toolbar_loc' => 'top',
'toolbar_align' => 'left',
'path_loc' => 'bottom',
'resizing' => 1,
'verify_html' => 1,
'preformatted' => 0,
'convert_fonts_to_spans' => 1,
'remove_linebreaks' => 1,
'apply_source_formatting' => 0,
'paste_auto_cleanup_on_paste' => 0,
'block_formats' => 'p,address,pre,h2,h3,h4,h5,h6,div',
'css_setting' => 'none',
'css_path' => '',
'css_classes' => '',
);

db_insert('wysiwyg')
->fields(array(
'format' => 'full_html',
'editor' => 'ckeditor',
'settings' => serialize($wysiwyg_settings),
))
->execute();
}

/**
* Setup Contact Form
*/
function jbasic_set_contact_form() {
// Create a Contact Us link in the main menu.
  $item = array(
    'link_title' => st('Contact Us'),
    'link_path' => 'contact',
    'menu_name' => 'main-menu',
'weight' => 1,
  );
  menu_link_save($item);

  // Update the menu router information.
  menu_rebuild();
}
