module ApplicationHelper
  def show_icon
    raw "<span title='Ver' class='ui-icon ui-icon-document'></span>"
  end

  def edit_icon
    raw "<span title='Editar' class='ui-icon ui-icon-pencil'></span>"
  end

  def delete_icon
    raw "<span title='Eliminar' class='ui-icon ui-icon-trash'></span>"
  end
end
