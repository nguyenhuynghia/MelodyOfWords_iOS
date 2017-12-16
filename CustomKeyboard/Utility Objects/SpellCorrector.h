//
//  SpellCorrector.h
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#ifndef __SoundBoard__SpellCorrector__
#define __SoundBoard__SpellCorrector__

#include <vector>
#include <map>

typedef std::vector<std::string> Vector;
typedef std::map<std::string, int> Dictionary;

class SpellCorrector
{
public:
   void load(const std::string& filename);
   Dictionary corrections(const std::string& word);

private:
   void editWord(const std::string& word, Vector& result);
   void known(Vector& results, Dictionary& candidates);

   Dictionary dictionary;
};

#endif /* defined(__SoundBoard__SpellCorrector__) */
