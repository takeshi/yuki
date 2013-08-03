Sequel.migration do
  change do
  	create_table :table_models do
  		String :table_name
		primary_key [:table_name]  		
  	end

  	create_table :colomn_models do
  		String :colomn_name
  		String :colomn_type
      foreign_key :table_name,:table_models,:type=>String
  		primary_key [:colomn_name,:table_name].sort
  	end
  	
  	create_table :sql_models do
  		String :sql_name
  		String :sql_template

  		primary_key [:sql_name]
  	end

  	create_table :type_models do
  		String :type_name
  		primary_key [:type_name]
  	end

  	create_table :type_colomns do
      String :colomn_name
      String :table_name
      foreign_key :type_name,:type_models,:type=>String
      foreign_key [:colomn_name,:table_name].sort,:colomn_models

  		primary_key [:colomn_name,:table_name,:type_name].sort
  	end

  end
end
