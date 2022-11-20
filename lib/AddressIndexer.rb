# -*- encoding: SHIFT_JIS -*-
# frozen_string_literal: true
require_relative "AddressIndexer/version"
require 'csv'
module AddressIndexer
  class Error < StandardError; end
  @@list =[]
  @@pairIndex ={}

  def loadCsvIntoListOfListAndIndexCols
    # CSV.foreachはフールパス必要なので、File.expand_pathを使用し,プロジェクトのルートパス取得する
    csvAddressPath = File.expand_path('./resources/csv/in/KEN_ALL.csv')
    csvAddressPath = File.expand_path('./resources/csv/in/test.csv')
    csvIndexOutPath = File.expand_path('./resources/csv/out/csvIndex.csv')
    recordNo=0   # レコード番号
    # Ruby提供するエンコードリスト:https://docs.ruby-lang.org/ja/latest/class/Encoding.html
    CSV.foreach(csvAddressPath ,:encoding=>'shift_jis', :headers=>false) do |str|
      # レコードがリストに格納する
      @@list[recordNo]=str
      compareCols =[6,7,8]                      # 希望カラムを設定
      compareCols.each { |colNumber|      # 希望カラムにループ
        stringLoop =0
        while stringLoop!=str[colNumber].length-1 do
          if @@pairIndex.has_key?(str[colNumber][stringLoop..stringLoop+1])
            # 存在する場合は行番号の存在確認と追加
            if(!@@pairIndex[str[colNumber][stringLoop..stringLoop+1]].include?recordNo)
              @@pairIndex[str[colNumber][stringLoop..stringLoop+1]].push(recordNo)
            end
          else
            # 存在しない場合キー追加と行番号追加
            @@pairIndex[str[colNumber][stringLoop..stringLoop+1]]=[recordNo]
          end
          stringLoop=stringLoop+1
        end
      }

      recordNo=recordNo+1
    end
  end
  def printListForUserInput(userInput)
    # 要件定義よりスペースは文字として扱わない。WhiteSpace削除
    userInput = userInput.encode('shift_jis')

    userInput = userInput.gsub(/[[:space:]]/, '')
    # CSVをロードし、カラム内容インデクスする
    loadCsvIntoListOfListAndIndexCols
    csvOutPath = File.expand_path('./resources/csv/out')+'/'+Time.new.strftime("%Y%m%d%H%M%S")+'.csv'
    keyExistsFlag = false
    lineNumberList = []
    userInputCharLoop = 0

    while userInputCharLoop!=userInput.length-1 do
      # ユーザ入力した値がHashにあるかどうか確認
      if @@pairIndex.has_key?userInput[userInputCharLoop..userInputCharLoop+1]
        # キー存在する場合はキー存在フラグをtrueに設定
        keyExistsFlag = true
        # リスト結合し、同じ値をコピーしない
        lineNumberList = lineNumberList | @@pairIndex[userInput[userInputCharLoop..userInputCharLoop+1]]
      end
      userInputCharLoop+=1
    end
    if keyExistsFlag == true
      # lineNumberListの情報より@@listに格納した情報出力
      CSV.open(csvOutPath, "wb") do |csv|
        lineNumberList.each { |lineNo|
          puts @@list[lineNo].to_s
          csv << @@list[lineNo]
        }
      end
    else
      puts '入力に対してレコードが見つかりませんでした'
    end
  end
  module_function :printListForUserInput
  module_function :loadCsvIntoListOfListAndIndexCols
end