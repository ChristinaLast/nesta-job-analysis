import csv
import gc
import re
from typing import Any, Sequence

import pandas as pd

import bootstrap  # noqa


class Preprocessing:
    def __init__(self, path_to_occupation_csv: str):
        self.path_to_occupation_csv = path_to_occupation_csv

    def execute(self) -> None:
        with open(self.path_to_occupation_csv, "r") as f:
            next(f)
            reader = csv.reader(f)
            input_array = list(reader)

        occupation_description_list = []
        occupation_description_no_punc_list = []
        for item in input_array:
            occupation_description_no_punc = self.remove_punctuation(item[5])
            self.append_occupation_description(
                occupation_description_list, occupation_description_no_punc
            )
            occupation_description_no_punc_list.append(occupation_description_no_punc)

        with open("data/processed_only_job_title_occupation.csv", "w") as f:
            for i in range(len(occupation_description_list)):
                writer = csv.writer(f)
                writer.writerow([input_array[i][3], occupation_description_no_punc_list[i]])

        return occupation_description_list

    def remove_punctuation(self, occupation_description: str) -> str:
        return re.sub(r"[^\w\s]", "", occupation_description)

    def append_occupation_description(
        self, occupation_description_list: Sequence[Any], item: str
    ) -> Sequence[str]:
        return occupation_description_list.append(item.split())
