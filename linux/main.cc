#include "my_application.h"

int main(int argc, char** argv) {
  g_autoptr(MyApplication) app = my_application_new();
  GtkWindow *window = my_application_create_window(app); // Esta función debe ser definida por ti
  gtk_window_set_default_size(GTK_WINDOW(window), 690, 720);
  gtk_widget_show_all(GTK_WIDGET(window));
  return g_application_run(G_APPLICATION(app), argc, argv);
}