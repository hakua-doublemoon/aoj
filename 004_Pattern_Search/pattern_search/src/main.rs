struct CharField {
    h: usize,
    w: usize,
    data: Vec<Vec<char>>,
    feature_x: usize,
    feature_y: usize,
}

impl CharField {
    pub fn new() -> CharField
    {
        let mut inputs = String::new();
        std::io::stdin().read_line(&mut inputs).ok();
        // 改行をtrimで除去して、whitespaceで分離（split）して、mapとparseでほしい型にして、
        // collectで配列として返させる。
        // parseはResult型を返すのでokで変換し、さらにSome型が出てくるのでunwrapで中身を取り出す。
        let hw :Vec<usize> = inputs.trim().split_whitespace().map(
                    |e| e.parse().ok().unwrap()
                  ).collect();
        CharField {
            h: hw[0],
            w: hw[1],
            data: Vec::new(),
            feature_x: 0,
            feature_y: 0,
        } // ここにセミコロンを付けないことで、値として返すことになる
    }

    pub fn read_data(&mut self)
    {
        for y in 0..self.h {
            // こうするとpushのときに速くなるらしい。
            // with_capacityは容量を確保しているわけではない（mallocとは違う）
            self.data.push(Vec::with_capacity(self.w)); 
            let mut inputs = String::new();
            std::io::stdin().read_line(&mut inputs).ok();
            // 入力の改行をtrimで除去して、charsで一文字ずつ取り出す
            // charsはChars型を返すみたいなのでそのままでもいいけど、
            // あえてc言語風に処理している、つもり。
            for c in inputs.trim().chars() {
                self.data[y].push(c);
            }
        }
    }

    pub fn get_tail_feature(&mut self)
    {
        let head = self.data[0][0];
        let mut y = self.h-1;
        let mut is_end = false;
        while  !is_end  {
            let mut x = self.w-1;
            loop {
                if  self.data[y as usize][x as usize] == head  {
                    if  x != 0  {
                        x -= 1;
                    } else {
                        break;
                    }
                    continue;
                }
                self.feature_y = y;
                self.feature_x = x;
                is_end = true;
                break;
            }
            if  y != 0  {
                y -= 1;
            } else {
                break;
            }
        }
        //println!("{} {}", self.feature_y, self.feature_x);
    }

    pub fn search(&self, template: &CharField)
    {
        let template_head = template.data[0][0];
        for y in 0..(self.h - template.h + 1) {
            for x in 0..(self.w - template.w + 1) {
                if  self.data[y][x] != template_head  {
                    continue;
                }
                if  self.is_match(y, x, template)  {
                    println!("{} {}", y, x);
                }
            }
        }
    }

    pub fn is_match(&self, y0: usize, x0: usize, template: &CharField) -> bool
    {
        let mut ret = true;
        // 特徴点照合
        let y = y0 + template.feature_y;
        let x = x0 + template.feature_x;
        if  self.data[y][x] != template.data[template.feature_y][template.feature_x]  {
            return false;
        }
        // 全面探索
        for y in y0..(y0 + template.h) {
            for x in x0..(x0 + template.w) {
                if  self.data[y][x] != template.data[y - y0][x - x0]  {
                    ret = false;
                    break;
                }
            }
            if  !ret  {
                break;
            }
        }
        ret
    }
}

fn main() {
    // 1行目: 縦 H × 横 W
    let mut origin = CharField::new();
    // 2行目以降: originオブジェクトにread_dataさせる
    origin.read_data();
    // H+1行目？:  縦 R × 横 C 
    let mut template = CharField::new();
    template.read_data();
    template.get_tail_feature();

    // マッチングする
    origin.search(&template);
}

