import 'package:tflite_flutter/tflite_flutter.dart';

extension CustomReshape on List {
  List reshapeCustom(List<int> shape) {
    int totalSize = shape.reduce((a, b) => a * b);
    if (this.length != totalSize) {
      throw Exception('Total size mismatch: Expected ${shape} but found ${this.length} elements');
    }
    List reshapedList = [];
    int start = 0;
    for (int i = 0; i < shape[0]; i++) {
      reshapedList.add(this.sublist(start, start + shape[1]));
      start += shape[1];
    }
    return reshapedList;
  }
}

class AIHelper {
  Interpreter? _interpreter;

  // Load the model from the assets
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/models/your_model.tflite');
  }

  // Run inference with reshaped input data and return the result as List<double>
  Future<List<double>> runInference(List<dynamic> input) async {
    // Convert input to List<int> (e.g., pixel data) and flatten it if necessary
    var int32Input = input.map((e) => e.toInt()).toList(); // Ensure it's in integer format
    print("Input length: ${int32Input.length}"); // Check input length

    // Use the custom reshape method to match model input dimensions (e.g., 1x28x28x1 for an image)
    var reshapedInput = int32Input.reshapeCustom([1, 28, 28, 1]); // Adjust dimensions as needed

    print("Reshaped Input: $reshapedInput"); // Debug print to ensure correct reshaping

    // Run inference with the reshaped input data
    var output = List.filled(10, 0.0); // Adjust the output size and type based on your model's output layer
    _interpreter?.run(reshapedInput, output);

    print("Model Output: $output"); // Debug print the output
    return output; // Return the result as List<double>
  }
}
