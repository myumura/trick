w = 80  # 画面の幅
h = 24  # 画面の高さ
f = []  # 降っている雪のリスト
m = 50  # 雪の最大数
ground = Array.new(w, 0)  # 地面の高さを記録する配列
snow_pile = Array.new(w) { Array.new(h, " ") }  # 積もった雪の文字を記録する配列
snow_chars = ["◯", "○", "●", "◎", "☃"]  # 積もった雪を表す文字

loop do
  # 新しい雪を追加
  f << {x: rand(w), y: 0, s: 0.1 + rand * 0.3, c: ["*", ".", "❄"].sample} if f.size < m && rand < 0.7
  
  # 画面クリア
  print "\e[2J\e[H"
  
  # 画面バッファの初期化
  s = Array.new(h) { " " * w }
  
  # 雪を更新
  f.each do |n|
    n[:y] += n[:s]
    n[:x] += rand(-0.3..0.3)
    n[:x] = [[n[:x], 0].max, w - 1].min
    
    x_i = n[:x].to_i
    y_i = n[:y].to_i
    
    # 雪が地面に到達したかチェック
    if y_i >= h - ground[x_i] - 1
      # 雪を地面に積もらせる
      ground[x_i] += 1
      
      # この位置の雪の文字をまだ決めていなければ、ランダムに選択して記録
      y_pos = h - ground[x_i]
      if y_pos >= 0 && snow_pile[x_i][y_pos] == " "
        snow_pile[x_i][y_pos] = snow_chars.sample
      end
      
      # 新しい雪を作成
      n[:y] = 0
      n[:x] = rand(w)
      
      # 山が高すぎる場合はなだらかにする（オプション）
      if x_i > 0 && ground[x_i] > ground[x_i-1] + 2
        ground[x_i] = ground[x_i-1] + 1
      end
      if x_i < w-1 && ground[x_i] > ground[x_i+1] + 2
        ground[x_i] = ground[x_i+1] + 1
      end
    end
    
    # 有効な座標なら雪を描画
    if y_i < h && y_i >= 0
      s[y_i][x_i] = n[:c] rescue nil
    end
  end
  
  # 積もった雪を描画（記録した文字を使用）
  ground.each_with_index do |height, x|
    height.times do |y|
      pos_y = h - y - 1
      if pos_y >= 0 && pos_y < h
        # 積もった雪の文字を表示（既に決まっている文字を使用）
        s[pos_y][x] = snow_pile[x][pos_y] if snow_pile[x][pos_y] != " "
      end
    end
  end
  
  # 画面を表示
  puts s
  
  # 少し待つ
  sleep 0.08
  
  # 終了条件（オプション：地面が高すぎる場合）
  break if ground.max > h / 2
end
