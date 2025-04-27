w = 80  # 画面の幅
h = 24  # 画面の高さ
f = []  # 降っている雪のリスト
m = 50  # 雪の最大数
ground = Array.new(w, 0)  # 地面の高さを記録する配列
snow_pile = Array.new(w) { Array.new(h, " ") }  # 積もった雪の文字を記録する配列
snow_chars = ["◯", "○", "●", "◎", "☃"]  # 積もった雪を表す文字

# 三角形の中心位置
center = w / 2
max_height = h / 2  # 三角形の最大高さ
slope = 0.5  # 三角形の傾斜（小さいほど急な傾斜）

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
    
    # 理想的な三角形の高さを計算（中心からの距離に応じて）
    target_height = max_height - (((x_i - center).abs) / slope).to_i
    target_height = [target_height, 0].max
    
    # 雪が地面に到達したかチェック
    if y_i >= h - ground[x_i] - 1
      # 雪を地面に積もらせる
      # 特定の位置の高さが三角形の理想的な高さを超えないようにする
      if ground[x_i] < target_height
        ground[x_i] += 1
      
        # この位置の雪の文字をまだ決めていなければ、ランダムに選択して記録
        y_pos = h - ground[x_i]
        if y_pos >= 0 && snow_pile[x_i][y_pos] == " "
          snow_pile[x_i][y_pos] = snow_chars.sample
        end
      end
      
      # 新しい雪を作成
      n[:y] = 0
      n[:x] = rand(w)
    end
    
    # 有効な座標なら雪を描画
    if y_i < h && y_i >= 0
      s[y_i][x_i] = n[:c] rescue nil
    end
  end
  
  # 自然な雪の動きを再現するため、積もった雪が側面に滑り落ちる効果を追加
  # しかし、実際に雪が落ちてきた場合のみ発生させる（自動的に三角形を形成しない）
  (1...w-1).each do |x|
    # 隣接する高さの差が大きすぎる場合、雪が滑り落ちる
    if ground[x] > 0 && x > 0 && x < w-1
      # 左側が2以上低い場合、左に滑り落ちる
      if ground[x] >= ground[x-1] + 2 && rand < 0.2
        ground[x] -= 1
        ground[x-1] += 1
        
        # 滑り落ちた雪の文字を更新
        y_from = h - ground[x] - 1
        y_to = h - ground[x-1]
        if y_to >= 0 && y_to < h && snow_pile[x-1][y_to] == " "
          # 元の場所の雪の文字を移動先に記録
          snow_pile[x-1][y_to] = snow_chars.sample
        end
      end
      
      # 右側が2以上低い場合、右に滑り落ちる
      if ground[x] >= ground[x+1] + 2 && rand < 0.2
        ground[x] -= 1
        ground[x+1] += 1
        
        # 滑り落ちた雪の文字を更新
        y_from = h - ground[x] - 1
        y_to = h - ground[x+1]
        if y_to >= 0 && y_to < h && snow_pile[x+1][y_to] == " "
          snow_pile[x+1][y_to] = snow_chars.sample
        end
      end
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
  
  # 終了条件：三角形がほぼ完成した場合
  if ground[center] >= max_height - 1
    # 三角形の形がある程度完成したら終了
    triangle_formed = true
    (0...w).each do |x|
      target_height = max_height - (((x - center).abs) / slope).to_i
      target_height = [target_height, 0].max
      # もし現在の高さが目標の80%未満なら、まだ完成していない
      if ground[x] < target_height * 0.8
        triangle_formed = false
        break
      end
    end
    break if triangle_formed
  end
end
