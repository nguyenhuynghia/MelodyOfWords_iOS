//
//  SpellCorrector.cpp
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#include "SpellCorrector.h"

#include <fstream>
#include <string>
#include <algorithm>
#include <iostream>

#include "SpellCorrector.h"

using namespace std;

bool sortBySecond(const pair<std::string, int>& left, const pair<std::string, int>& right)
{
   return left.second < right.second;
}

char filterNonAlphabetic(char& letter)
{
   if (isalpha(letter))
   {
      return tolower(letter);
   }
   else if (letter == '\'')
   {
      return letter;
   }
   return '-';
}

void SpellCorrector::load(const std::string& filename)
{
   ifstream file(filename.c_str(), ios_base::binary | ios_base::in);

   file.seekg(0, ios_base::end);
   long long int length = file.tellg();
   file.seekg(0, ios_base::beg);

   string line(length, '0');

   file.read(&line[0], length);

   line.erase(std::remove(line.begin(), line.end(), '\''), line.end());
   transform(line.begin(), line.end(), line.begin(), filterNonAlphabetic);

   string::size_type begin = 0;
   string::size_type end = line.size();

   for (string::size_type i = 0;;)
   {
      while (line[++i] == '-' && i < end); // find first '-' character

      if (i >= end)
      {
         break;
      }

      begin = i;
      while (line[++i] != '-' && i < end); // find first character that is not '-'

      dictionary[line.substr(begin, i - begin)]++;
   }
}

Dictionary SpellCorrector::corrections(const std::string& word)
{
   Vector result;
   Dictionary candidates;

   // if the word is correctly spelled, then don't try to find a correction
   if (dictionary.find(word) != dictionary.end())
   {
      return candidates;
   }

   editWord(word, result);
   known(result, candidates);

   if (candidates.size() > 0)
   {
      return candidates;
   }

   for (unsigned int i = 0; i < result.size(); i++)
   {
      Vector subResult;

      editWord(result[i], subResult);
      known(subResult, candidates);
   }

   if (candidates.size() > 0)
   {
      return candidates;
   }

   candidates.clear();
   return candidates;
}

void SpellCorrector::known(Vector& results, Dictionary& candidates)
{
   Dictionary::iterator end = dictionary.end();
   for (unsigned int i = 0; i < results.size(); i++)
   {
      Dictionary::iterator value = dictionary.find(results[i]);

      if (value != end)
      {
         candidates[value->first] = value->second;
      }
   }
}

void SpellCorrector::editWord(const std::string& word, Vector& result)
{
   for (string::size_type characterIndex = 0; characterIndex < word.size(); characterIndex++)
   {
      result.push_back(word.substr(0, characterIndex) + word.substr(characterIndex + 1)); // deletions
   }
   for (string::size_type characterIndex = 0; characterIndex < word.size() - 1; characterIndex++)
   {
      result.push_back(word.substr(0, characterIndex) + word[characterIndex + 1] + word[characterIndex] + word.substr(characterIndex + 2)); // transposition
   }

   for (char j = 'a'; j <= 'z'; ++j)
   {
      for (string::size_type i = 0; i < word.size(); i++)
      {
         result.push_back(word.substr(0, i) + j + word.substr(i + 1)); // alterations
      }
      for (string::size_type i = 0; i < word.size() + 1; i++)
      {
         result.push_back(word.substr(0, i) + j + word.substr(i)); // insertion
      }
   }
}
