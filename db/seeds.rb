require 'open-uri'

LOREM_LONG = <<-END_LOREM
    <p>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a ante et dolor vehicula auctor. Cras sem magna, venenatis non pharetra ac, pellentesque at dui. Sed sit amet nulla nulla, at imperdiet lacus. Aenean tellus turpis, pretium in facilisis a, vestibulum sit amet ante. Quisque bibendum nisi ac magna blandit at eleifend turpis gravida. Curabitur quis massa ac magna molestie pharetra at a eros. Phasellus vulputate neque sit amet est faucibus mattis. Mauris adipiscing orci at augue interdum sit amet commodo tortor consectetur. Etiam eleifend congue risus vitae ultricies. Donec feugiat volutpat pharetra. Maecenas non fermentum magna. Sed facilisis vulputate dui in pellentesque. Praesent eget magna non orci posuere pretium. Ut sit amet lobortis ligula.
    </p>
    <p>
      Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse eu felis eu turpis elementum mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi auctor hendrerit enim non aliquam. In mollis fringilla ante, sed feugiat erat pretium volutpat. Curabitur ut urna vitae magna venenatis varius sit amet in sapien. Cras nec turpis sem. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec consequat volutpat lectus vel mollis. Morbi iaculis, felis ut tempus placerat, tortor risus iaculis arcu, sit amet imperdiet risus lectus vel odio. Nullam in risus purus, ut tincidunt lacus.
    </p>
  END_LOREM

LOREM_SHORT = <<-END_LOREM
    <p>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a ante et dolor vehicula auctor. Cras sem magna, venenatis non pharetra ac, pellentesque at dui. Sed sit amet nulla nulla, at imperdiet lacus. Aenean tellus turpis, pretium in facilisis a, vestibulum sit amet ante.
    </p>
  END_LOREM

LOREM_MICRO = <<-END_LOREM
    <p>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a ante et dolor vehicula auctor.
    </p>
  END_LOREM

LOREM_SANS_HTML = <<-END_LOREM
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a ante et dolor vehicula auctor.
  END_LOREM

id = 0
Product.all.each(&:destroy)
%w{boat plane train}.each do |product|
  attr = {
    :name => product,
    :price => "100",
    :index_attributes => {
      :name => product,
      :page_title => APP_CONFIG[:app_name] + " - " + product.capitalize,
      :page_description => APP_CONFIG[:app_name] + " - " + product.capitalize,
      :keywords => product,
      :texts_attributes => {
        (id += 1).to_s =>{
          :content => "#{LOREM_SHORT}",
          :priority => "1"
        }
      }
    }
  }
  Product.create(attr)
end