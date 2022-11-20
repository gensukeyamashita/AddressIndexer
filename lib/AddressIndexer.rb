# -*- encoding: SHIFT_JIS -*-
# frozen_string_literal: true
require_relative "AddressIndexer/version"
require 'csv'
module AddressIndexer
  class Error < StandardError; end
  @@list =[]
  @@pairIndex ={}

  def loadCsvIntoListOfListAndIndexCols
    # CSV.foreach�̓t�[���p�X�K�v�Ȃ̂ŁAFile.expand_path���g�p��,�v���W�F�N�g�̃��[�g�p�X�擾����
    csvAddressPath = File.expand_path('./resources/csv/in/KEN_ALL.csv')
    csvAddressPath = File.expand_path('./resources/csv/in/test.csv')
    csvIndexOutPath = File.expand_path('./resources/csv/out/csvIndex.csv')
    recordNo=0   # ���R�[�h�ԍ�
    # Ruby�񋟂���G���R�[�h���X�g:https://docs.ruby-lang.org/ja/latest/class/Encoding.html
    CSV.foreach(csvAddressPath ,:encoding=>'shift_jis', :headers=>false) do |str|
      # ���R�[�h�����X�g�Ɋi�[����
      @@list[recordNo]=str
      compareCols =[6,7,8]                      # ��]�J������ݒ�
      compareCols.each { |colNumber|      # ��]�J�����Ƀ��[�v
        stringLoop =0
        while stringLoop!=str[colNumber].length-1 do
          if @@pairIndex.has_key?(str[colNumber][stringLoop..stringLoop+1])
            # ���݂���ꍇ�͍s�ԍ��̑��݊m�F�ƒǉ�
            if(!@@pairIndex[str[colNumber][stringLoop..stringLoop+1]].include?recordNo)
              @@pairIndex[str[colNumber][stringLoop..stringLoop+1]].push(recordNo)
            end
          else
            # ���݂��Ȃ��ꍇ�L�[�ǉ��ƍs�ԍ��ǉ�
            @@pairIndex[str[colNumber][stringLoop..stringLoop+1]]=[recordNo]
          end
          stringLoop=stringLoop+1
        end
      }

      recordNo=recordNo+1
    end
  end
  def printListForUserInput(userInput)
    # �v����`���X�y�[�X�͕����Ƃ��Ĉ���Ȃ��BWhiteSpace�폜
    userInput = userInput.encode('shift_jis')

    userInput = userInput.gsub(/[[:space:]]/, '')
    # CSV�����[�h���A�J�������e�C���f�N�X����
    loadCsvIntoListOfListAndIndexCols
    csvOutPath = File.expand_path('./resources/csv/out')+'/'+Time.new.strftime("%Y%m%d%H%M%S")+'.csv'
    keyExistsFlag = false
    lineNumberList = []
    userInputCharLoop = 0

    while userInputCharLoop!=userInput.length-1 do
      # ���[�U���͂����l��Hash�ɂ��邩�ǂ����m�F
      if @@pairIndex.has_key?userInput[userInputCharLoop..userInputCharLoop+1]
        # �L�[���݂���ꍇ�̓L�[���݃t���O��true�ɐݒ�
        keyExistsFlag = true
        # ���X�g�������A�����l���R�s�[���Ȃ�
        lineNumberList = lineNumberList | @@pairIndex[userInput[userInputCharLoop..userInputCharLoop+1]]
      end
      userInputCharLoop+=1
    end
    if keyExistsFlag == true
      # lineNumberList�̏����@@list�Ɋi�[�������o��
      CSV.open(csvOutPath, "wb") do |csv|
        lineNumberList.each { |lineNo|
          puts @@list[lineNo].to_s
          csv << @@list[lineNo]
        }
      end
    else
      puts '���͂ɑ΂��ă��R�[�h��������܂���ł���'
    end
  end
  module_function :printListForUserInput
  module_function :loadCsvIntoListOfListAndIndexCols
end