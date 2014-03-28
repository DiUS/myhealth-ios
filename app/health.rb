class Health

  attr_accessor :emergencyName, :emergencyTel, :name, :conditions, :allergies, :qrcode

  def self.fromJson(json, qrcode)
    p "Creating health record from #{json}"
    health = Health.new
    health.qrcode = qrcode
    health.emergencyName = json[:contact][:name]
    health.emergencyTel = json[:contact][:phone]
    health.name = json[:name]
    # health.conditions = "Heart attacks\n\tEpileptic fits"
    health.conditions = json[:conditions].collect {|c| c[:name]}
    health.allergies = ["Penicillin"]
    # health.allergies = json[:allergies].collect {|a| a[:name]}
    health
  end

  def self.formFrom(health)
    @form = Formotion::Form.new(
    {
      sections:
      [
        {
          title: "In case of emergency call",
          rows:
          [
            { title: "Name",
              key: :name,
              placeholder: "Joe Bloggs",
              type: :string,
              auto_correction: :no,
              auto_capitalization: :none,
              value: health.emergencyName },
            { title: "Tel",
              key: :phone,
              placeholder: "+61 458884261",
              type: :string,
              value: health.emergencyTel }
          ]
        },
        {
          title: "My details",
          rows:
          [
            { title: "My name",
              key: :name,
              placeholder: "Joe Bloggs",
              type: :string,
              auto_correction: :no,
              auto_capitalization: :none,
              value: health.name
            }
          ]
        },
        {
          title: "I suffer from",
          rows:
          [
            { title: "Conditions",
              key: :name,
              placeholder: "Conditions",
              type: :string,
              auto_correction: :no,
              auto_capitalization: :none,
              value: health.conditions.join(', ')
            }
          ]
        },
        {
          title: "Don't give me",
          rows:
          [
            { title: "Allergies",
              key: :name,
              placeholder: "Allergies",
              type: :string,
              auto_correction: :no,
              auto_capitalization: :none,
              value: health.allergies.join(', ')
            }
          ]
        }
      ] #end sections
    })
  end

end