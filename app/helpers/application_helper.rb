module ApplicationHelper

  def external_url(url)
    if url.start_with?('http://', 'https://')
      url
    else
      "http://#{url}"
    end
  end

# TODO - move it out
  def correct_user?(user)
    user_log_in? && current_user == user
  end

  def random_color
    ["Black", "Navy", "DarkBlue", "MediumBlue", "Blue", "DarkGreen", "Green", "Teal", "DarkCyan", "DeepSkyBlue", "DarkTurquoise", "MediumSpringGreen", "Lime", "SpringGreen", "Aqua", "Cyan", "MidnightBlue", "DodgerBlue", "LightSeaGreen", "ForestGreen", "SeaGreen", "DarkSlateGray", "LimeGreen", "MediumSeaGreen", "Turquoise", "RoyalBlue", "SteelBlue", "DarkSlateBlue", "MediumTurquoise", "Indigo", "DarkOliveGreen", "CadetBlue", "CornflowerBlue", "RebeccaPurple", "MediumAquaMarine", "DimGray", "SlateBlue", "OliveDrab", "SlateGray", "LightSlateGray", "MediumSlateBlue", "LawnGreen", "Chartreuse", "Aquamarine", "Maroon", "Purple", "Olive", "Gray", "SkyBlue", "LightSkyBlue", "BlueViolet", "DarkRed", "DarkMagenta", "SaddleBrown", "DarkSeaGreen", "LightGreen", "MediumPurple", "DarkViolet", "PaleGreen", "DarkOrchid", "YellowGreen", "Sienna", "Brown", "DarkGray", "LightBlue", "GreenYellow", "PaleTurquoise", "LightSteelBlue", "PowderBlue", "FireBrick", "DarkGoldenRod", "MediumOrchid", "RosyBrown", "DarkKhaki", "Silver", "MediumVioletRed", "IndianRed", "Peru", "Chocolate", "Tan", "LightGray", "Thistle", "Orchid", "GoldenRod", "PaleVioletRed", "Crimson", "Gainsboro", "Plum", "BurlyWood", "LightCyan", "Lavender", "DarkSalmon", "Violet", "PaleGoldenRod", "LightCoral", "Khaki", "AliceBlue", "HoneyDew", "Azure", "SandyBrown", "Wheat", "Beige", "WhiteSmoke", "MintCream", "GhostWhite", "Salmon", "AntiqueWhite", "Linen", "LightGoldenRodYellow", "OldLace", "Red", "Fuchsia", "Magenta", "DeepPink", "OrangeRed", "Tomato", "HotPink", "Coral", "DarkOrange", "LightSalmon", "Orange", "LightPink", "Pink", "Gold", "PeachPuff", "NavajoWhite", "Moccasin", "Bisque", "MistyRose", "BlanchedAlmond", "PapayaWhip", "LavenderBlush", "SeaShell", "Cornsilk", "LemonChiffon", "FloralWhite", "Snow", "Yellow", "LightYellow", "Ivory", "White"].sample
  end

# refactoring today
  def caret_vote_icon(votable, direction = :up)
    if direction == :up
      vote_up_arrow(votable)
    elsif direction == :down
      vote_down_arrow(votable)
    else
    end
  end

  def condition(votable)
    if user_log_in? && (user_vote = current_user.votes.where(votable: votable).take)
      if user_vote.voted == true
        :two
      elsif user_vote.voted == false
        :three
      else
        :one
      end
    else
      :one
    end
  end

  def vote_down_arrow(votable)
    name_of_icon = "caret-down 2x"
    vote_of_icon = false

    case condition(votable)
    when :three
      link_to fa_icon(name_of_icon, style: "color: OrangeRed;"), {voted: nil, controller: votable.class.to_s.downcase.pluralize, id: votable, action: 'vote'}, method: 'post'
    else
      link_to fa_icon(name_of_icon, style: "color: gray;"), {voted: vote_of_icon, controller: votable.class.to_s.downcase.pluralize, id: votable, action: 'vote'}, method: 'post'
    end
  end

  def vote_up_arrow(votable)
    name_of_icon = "caret-up 2x"
    vote_of_icon = true

    case condition(votable)
    when :two
      link_to fa_icon(name_of_icon, style: "color: OrangeRed;"), {voted: nil, controller: votable.class.to_s.downcase.pluralize, id: votable, action: 'vote'}, method: 'post'
    else
      link_to fa_icon(name_of_icon, style: "color: gray;"), {voted: vote_of_icon, controller: votable.class.to_s.downcase.pluralize, id: votable, action: 'vote'}, method: 'post'
    end
  end
end
