require_relative 'oo_structured_state'
require_relative 'function_state'
require_relative 'class_state'
require_relative 'idle_state'

module StateMachine

  module OOStructuredFSM

    # Class responsible for handling Module state.
    class ModuleState < OOStructuredState

      @language

      def initialize(pLanguage)
        @language = pLanguage
      end

      # @see OOStructuredState
      def handle_line(pLine)
        if @language.classHandler.get_class(pLine)
          class_capture
        elsif @language.functionHandler.get_function(pLine)
          function_capture
        elsif @language.variableHandler.get_variable(pLine)
          variable_capture
        end
      end

      # @see OOStructuredState
      def idle_capture
        @language.set_state(@language.idleState)
      end

      # @see OOStructuredState
      def class_capture
        @language.set_state(@language.classState)
      end

      # @see OOStructuredState
      def variable_capture
        @language.set_state(@language.variableState)
      end

      # @see OOStructuredState
      def function_capture
        @language.set_state(@language.functionState)
      end

      # @see OOStructuredState
      def execute(pElementFile, pLine)

        moduleElement = @language.moduleHandler.get_module(pLine)

        if moduleElement
          pElementFile.add_modules(moduleElement)
        end

        if @language.endBlockHandler.has_end_of_block?(pLine)
          previous = @language.previousState.last

          if (previous.is_a?(StateMachine::OOStructuredFSM::IdleState))
            idle_capture
          else
            return pElementFile
          end
        end

        return pElementFile
      end

    # End class
    end

  # End OOStructuredFSM
  end

# End StateMachine
end
