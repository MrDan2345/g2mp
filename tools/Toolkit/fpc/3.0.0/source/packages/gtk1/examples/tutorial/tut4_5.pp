{

  This file extracted from the GTK 1.2 tutorial.
  Section 4.5

  Converted from C to Pascal by Thomas E. Payne
}
program Tut4_5;

{$mode objfpc}

uses
 glib,gdk,gtk,sysutils;


//* Our callback.
//* The data passed to this function is printed to stdout */
procedure callback(widget : pGtkWidget ; data: pgpointer ); cdecl;
begin
  writeln('Hello again - '+pchar(data)+' was pressed');
end;

//* This callback quits the program */
function delete_event (widget : pGtkWidget ; event: pGdkEvent; data: pgpointer ): integer; cdecl;
begin
  gtk_main_quit();
  delete_event:=0;
end;

var
  window, button, table :pGtkWidget;
begin
  gtk_init (@argc, @argv);

  //* Create a new window */
  window := gtk_window_new (GTK_WINDOW_TOPLEVEL);

  //* Set the window title */
  gtk_window_set_title (GTK_WINDOW (window), 'Table');

  //* Set a handler for delete_event that immediately
  //* exits GTK. */
  gtk_signal_connect (GTK_OBJECT (window), 'delete_event',
                     GTK_SIGNAL_FUNC (@delete_event), NIL);

  //* Sets the border width of the window. */
  gtk_container_set_border_width (GTK_CONTAINER (window), 20);

  //* Create a 2x2 table */
  table := gtk_table_new (2, 2, TRUE);

  //* Put the table in the main window */
  gtk_container_add (GTK_CONTAINER (window), table);

  //* Create first button */
  button := gtk_button_new_with_label ('button 1');

  //* When the button is clicked, we call the "callback" function
  //* with a pointer to "button 1" as its argument */
  gtk_signal_connect (GTK_OBJECT (button), 'clicked',
                  GTK_SIGNAL_FUNC (@callback), pchar('button 1'));

  //* Insert button 1 into the upper left quadrant of the table */
  gtk_table_attach_defaults (GTK_TABLE(table), button, 0, 1, 0, 1);

  gtk_widget_show (button);

  //* Create second button */

  button := gtk_button_new_with_label ('button 2');

  //* When the button is clicked, we call the "callback" function
  //* with a pointer to "button 2" as its argument */
  gtk_signal_connect (GTK_OBJECT (button), 'clicked',
                  GTK_SIGNAL_FUNC (@callback), pchar('button 2'));
  //* Insert button 2 into the upper right quadrant of the table */
  gtk_table_attach_defaults (GTK_TABLE(table), button, 1, 2, 0, 1);

  gtk_widget_show (button);

  //* Create "Quit" button */
  button := gtk_button_new_with_label ('Quit');

  //* When the button is clicked, we call the "delete_event" function
  //* and the program exits */
  gtk_signal_connect (GTK_OBJECT (button), 'clicked',
                            GTK_SIGNAL_FUNC (@delete_event), NIL);

  //* Insert the quit button into the both
  //* lower quadrants of the table */
  gtk_table_attach_defaults (GTK_TABLE(table), button, 0, 2, 1, 2);
  gtk_widget_show (button);

  gtk_widget_show (table);
  gtk_widget_show (window);

  gtk_main ();
end.
