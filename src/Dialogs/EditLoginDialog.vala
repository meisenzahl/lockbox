/*
* Copyright (c) 2018 skärva LLC. <https://skarva.tech>
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

namespace Kipeltip.Dialogs {
    public class EditLoginDialog : Gtk.Dialog {
        private int id;
        private Gtk.Entry name_entry;
        private Gtk.Entry username_entry;
        private Gtk.Entry password_entry;

        public signal void update_login (Interfaces.Login entry);

        public EditLoginDialog (Gtk.Window? parent, Interfaces.Login entry) {
            Object (
                border_width: 12,
                deletable: false,
                resizable: false,
                title: _("Edit Login"),
                transient_for: parent
            );

            set_default_response (Gtk.ResponseType.OK);
            this.id = entry.id;
            name_entry.text = entry.name;
            username_entry.text = entry.username;
            password_entry.text = entry.password;
        }

        construct {
            var grid = new Gtk.Grid ();
            grid.column_spacing = 12;
            grid.row_spacing = 6;
            grid.margin_bottom = 12;
            get_content_area ().add (grid);

            var header = new Granite.HeaderLabel (_("Edit Login"));
            grid.attach (header, 0, 0, 2, 1);

            var name_label = new Gtk.Label (_("Name:"));
            name_label.halign = Gtk.Align.END;
            name_label.margin_start = 12;
            name_entry = new Gtk.Entry ();
            name_entry.activates_default = true;
            grid.attach (name_label, 0, 1, 1, 1);
            grid.attach (name_entry, 1, 1, 1, 1);

            var username_label = new Gtk.Label (_("Username:"));
            username_label.halign = Gtk.Align.END;
            username_label.margin_start = 12;
            username_entry = new Gtk.Entry ();
            username_entry.activates_default = true;
            grid.attach (username_label, 0, 2, 1, 1);
            grid.attach (username_entry, 1, 2, 1, 1);

            var password_label = new Gtk.Label (_("Password:"));
            password_label.halign = Gtk.Align.END;
            password_label.margin_start = 12;
            password_entry = new Gtk.Entry ();
            password_entry.input_purpose = Gtk.InputPurpose.PASSWORD;
            password_entry.invisible_char = '*';
            password_entry.visibility = false;
            password_entry.activates_default = true;
            grid.attach (password_label, 0, 3, 1, 1);
            grid.attach (password_entry, 1, 3, 1, 1);

            var close_button = add_button (_("Cancel"), Gtk.ResponseType.CLOSE);
            var ok_button = add_button (_("Update Login"), Gtk.ResponseType.OK);

            response.connect (on_response);
        }

        private void on_response (Gtk.Dialog source, int response_id) {
            switch (response_id) {
                case Gtk.ResponseType.OK:
                    if (name_entry.text_length == 0 || username_entry.text_length == 0 || password_entry.text_length == 0) {
                        var alert = new Granite.MessageDialog.with_image_from_icon_name (
                            _("Some fields are still empty!"),
                            _("You must fill in all the fields in order to save your login info."),
                            "dialog-error",
                            Gtk.ButtonsType.CLOSE
                        );
                        alert.run ();
                        alert.destroy ();
                    } else {
                        var login = new Interfaces.Login (name_entry.text.strip (), username_entry.text.strip (), password_entry.text.strip ());
                        login.id = id;
                        update_login (login);
                        destroy ();
                    }
                    break;
                case Gtk.ResponseType.CLOSE:
                    destroy ();
                    break;
            }
        }
    }
}
