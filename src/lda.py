import csv
import re
import time
from typing import Any, List, Sequence, Tuple

import gensim
from gensim import corpora, models
from nltk.stem.porter import PorterStemmer
from nltk.tokenize import RegexpTokenizer
from sklearn.manifold import TSNE
from stop_words import get_stop_words

import bootstrap  # noqa


class OccupationLDA:
    def __init__(self, en_stop: Sequence[Any]):
        self.en_stop = en_stop
        self.tokenizer = RegexpTokenizer(r"\w+")
        self.p_stemmer = PorterStemmer()

    def execute(self, path_to_processed_occupation_csv: str) -> None:
        lookup = {}
        occupation_description_set = []
        with open(path_to_processed_occupation_csv) as f:
            next(f)
            reader = csv.reader(f, delimiter=",")
            row_num = 0
            for row in reader:
                lookup[row_num] = row[0]
                occupation_description_set.append(row[1].lower())
                row_num += 1

        texts = []

        for occupation_description in occupation_description_set:
            occupation_description_no_punc = self.remove_punctuation(occupation_description)
            stopped_tokens = self.remove_stopwords(occupation_description_no_punc)
            stemmed_tokens = []
            for word in stopped_tokens:
                stemmed_tokens = self.stem_tokens(word, stemmed_tokens)

            texts.append(stemmed_tokens)
        # print(texts)

        text_dictionary = corpora.Dictionary(texts)
        corpus = self.tokenised_descriptions_to_dict(texts, text_dictionary)
        num_topics = 10
        lda_model = self.generate_lda_model(corpus, num_topics, text_dictionary)

        with open(f"data/lda_{str(num_topics)}_topics.csv", "w") as f:
            writer = csv.writer(f)
            for i in range(num_topics):
                writer.writerow([i, lda_model.print_topic(i)])

        print("topics", time.strftime("%H:%M:%S"))

        lda_model.save(f"models/occupations_lda_{str(num_topics)}_topics_model")

        print("saved", time.strftime("%H:%M:%S"))

        with open(f"data/occupations_lda_{str(num_topics)}_topics.csv", "w") as f:
            writer = csv.writer(f)
            for j in range(len(lookup)):
                topics = lda_model.get_document_topics(corpus[j])
                topics_list = [list(i) for i in topics]
                topics_list_flat = [item for sublist in topics_list for item in sublist]
                temp = [j, lookup[j]] + topics_list_flat
                writer.writerow(temp)

    def remove_punctuation(self, occupation_description: str) -> str:
        return re.sub(r"[^\w\s]", "", occupation_description)

    def remove_stopwords(self, doc):
        raw_doc = doc.lower()
        tokens = self.tokenizer.tokenize(raw_doc)
        # remove stop words from tokens
        return [i for i in tokens if not i in self.en_stop]

    def stem_tokens(self, word: str, stemmed_tokens: List[Any]) -> List[Any]:
        try:
            stemmed_tokens.append(self.p_stemmer.stem(word))
        except UnicodeDecodeError:
            stemmed_tokens.append(word)

        return stemmed_tokens

    def tokenised_descriptions_to_dict(
        self, texts: List[Any], text_dictionary: corpora.Dictionary
    ) -> List[Any]:
        return [text_dictionary.doc2bow(text) for text in texts]

    def generate_lda_model(
        self, corpus: List[Any], num_topics: int, text_dictionary: List[Any]
    ) -> gensim.models.ldamodel.LdaModel:
        return gensim.models.ldamodel.LdaModel(
            corpus, num_topics=num_topics, id2word=text_dictionary, passes=100
        )
