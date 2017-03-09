class AlterCoursesFields < ActiveRecord::Migration[5.0]
  def up
  	remove_column("courses","registration") 
  	remove_column("courses","strict_isa") 
  	remove_column("courses","evaluation") 
    change_column("courses","name",:string, :limit => 80, :null => false)
    change_column("courses","description",:text, :limit => 1000)
  	add_column("courses","initials", :string, :limit => 8, :after => "name") 
  	add_column("courses","period_type", :string, :limit => 45, :after => "initials") # semanas, meses, semestres..
  	add_column("courses","period_length", :integer, :limit => 1, :after => "period_type") # En enteros si el limite es uno rails creara un tinyint, maximo valor es 127
  	add_column("courses","section", :string, :limit => 2, :after => "period_type") 
  	add_column("courses","category", :string, :limit => 45, :after => "section") 
  	add_column("courses","institute", :string, :limit => 100, :after => "category") 
  	add_column("courses","content", :string, :limit => 120, :after => "institute") 
  	add_column("courses","privacy",  :string, :limit => 15, :after => "content") #Deberia ser algo asi "ENUM('PUBLIC', 'PRIVATE')" pero rails no admite enums por defecto
  	add_column("courses","inscriptions_activated", :boolean, :after => "privacy") 
  	add_column("courses","evaluate_teacher", :boolean, :after => "inscriptions_activated") 
  	add_column("courses","strict_mode_isa", :boolean, :after => "evaluate_teacher") 
  	add_column("courses","code_confirmed", :boolean, :after => "strict_mode_isa") #Esto es para indicar si se aceptan los miembros del curso con codigo o notificacion
  	add_column("courses","logo", :string, :limit => 200,  :after => "code_confirmed") 
  end

  def down
  	remove_column("courses","logo") 
  	remove_column("courses","code_confirmed") 
  	remove_column("courses","strict_mode_isa")
  	remove_column("courses","evaluate_teacher")  
  	remove_column("courses","inscriptions_activated") 
  	remove_column("courses","privacy")
  	remove_column("courses","content") 
  	remove_column("courses","institute") 
  	remove_column("courses","category") 
  	remove_column("courses","section") 
  	remove_column("courses","period_length") 
  	remove_column("courses","period_type") 
  	remove_column("courses","initials") 
    change_column("courses","description",:text, :limit => 65535)
    change_column("courses","name",:string, :limit => 32, :null => false)
  	add_column("courses","registration", :string, :limit => 255, :after => "description") 
  	add_column("courses","strict_isa", :string, :limit => 255, :after => "registration")
  	add_column("courses","evaluation", :string, :limit => 255, :after => "strict_isa")
  end
end