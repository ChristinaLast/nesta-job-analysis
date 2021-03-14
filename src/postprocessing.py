import csv
from typing import Any, List, Sequence, Tuple

import bootstrap  # noqa


class Postprocessing:
    def __init__(self, path_to_occupation_lda_csv: str):
        self.path_to_occupation_lda_csv = path_to_occupation_lda_csv

    def execute(self) -> None:
        postprocessed_set = []
        with open(self.path_to_occupation_lda_csv) as f:
            next(f)
            reader = csv.reader(f, delimiter=",")
            row_num = 0
            for row in reader:
                # print("row before postprocessing: ", row)
                full_processed_row = self.sort_columns(row)
                postprocessed_set.append(full_processed_row)
        with open(f"data/postprocessed_occupations_lda_10_topics.csv", "w") as f:
            writer = csv.writer(f)
            writer.writerows(postprocessed_set)

    def sort_columns(self, row):
        topic_list = row[2::2]
        probability_list = row[3::2]
        topic_index_list = [int(20 * (int(x) / 10)) for x in topic_list]
        probability_index_list = [int((20 * (int(x) / 10)) + 1) for x in topic_list]
        index_and_job_title = row[:2]
        full_len_processed_row = [
            0,
            0.00000000,
            1,
            0.00000000,
            2,
            0.00000000,
            3,
            0.00000000,
            4,
            0.00000000,
            5,
            0.00000000,
            6,
            0.00000000,
            7,
            0.00000000,
            8,
            0.00000000,
            9,
            0.00000000,
        ]
        for topic_num, probaility_num, topic_index, probability_index in zip(
            topic_list, probability_list, topic_index_list, probability_index_list
        ):
            if topic_num == "1":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "2":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "3":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "4":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "5":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "6":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "7":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "8":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
            if topic_num == "9":
                full_len_processed_row[topic_index] = topic_num
                full_len_processed_row[probability_index] = probaility_num
        full_processed_row = index_and_job_title + full_len_processed_row
        return full_processed_row
